import 'package:flutter/material.dart';
import 'package:genreguesser/models/option.dart';
import 'package:genreguesser/models/question.dart';
import 'package:genreguesser/models/question_image.dart';
import 'package:genreguesser/models/quiz_item.dart';
import 'package:genreguesser/services/quiz_service.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int? selectedOptionIndex;
  bool? answerCorrect;
  bool answered = false;
  QuizService quizService = QuizService();
  QuizItem currentQuizItem = QuizItem.init();

  @override
  void initState() {
    getNextQuestion();
  }

  void getNextQuestion() {
    setState(() {
      selectedOptionIndex = null;
      answerCorrect = null;
      answered = false;
      currentQuizItem = quizService.get();
    });
  }

  Widget quizImage(QuestionImage questionImage) {
    return Column(
      children: [
        Image.network(questionImage.src),
        Text(questionImage.title),
        Text(questionImage.subTitle)
      ],
    );
  }

  Widget quizQuestion(Question question) {
    return Column(
      children: [
        Text(question.text),
        ListView.builder(
            shrinkWrap: true,
            itemCount: question.options.length,
            itemBuilder: (BuildContext context, int index) => TextButton(
                child: Text(question.options[index].text),
                style: TextButton.styleFrom(
                  backgroundColor: buttonColor(question.options[index]),
                ),
                onPressed: () => handleOptionClick(index, question.options)))
      ],
    );
  }

  Color buttonColor(Option option) {
    if (!answered) {
      return Colors.black;
    } else if (option.correct) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  void handleOptionClick(int optionIndex, List<Option> options) {
    setState(() {
      selectedOptionIndex = optionIndex;
      answerCorrect = options[optionIndex].correct;
      answered = true;
    });
  }

  Widget quizItemDisplay(QuizItem item) {
    return Column(
        children: [quizImage(item.image), quizQuestion(item.question)]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        quizItemDisplay(currentQuizItem),
        TextButton(
          onPressed: answered ? getNextQuestion : null,
          child: const Text("Next question"),
        )
      ],
    ));
  }
}
