import 'package:flutter/material.dart';
import 'package:genrle/models/option.dart';
import 'package:genrle/models/question.dart';
import 'package:genrle/models/question_image.dart';
import 'package:genrle/models/quiz_item.dart';
import 'package:genrle/services/quiz_service.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  bool? answerCorrect;
  bool answered = false;
  Option? selectedOption;
  QuizService quizService = QuizService();
  QuizItem currentQuizItem = QuizItem.init();

  @override
  void initState() {
    super.initState();
    getNextQuestion();
  }

  void getNextQuestion() {
    setState(() {
      selectedOption = null;
      answerCorrect = null;
      answered = false;
      currentQuizItem = quizService.get();
    });
  }

  Widget quizImage(QuestionImage questionImage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 200,
              child: Image.network(
                questionImage.src,
                height: 200,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            Text(questionImage.title),
            Text(questionImage.subTitle)
          ],
        ),
      ),
    );
  }

  Widget quizQuestion(Question question) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("Q: ${question.text}"),
          SizedBox(
            height: 16,
          ),
          Column(
              children: question.options
                  .map((option) => TextButton(
                      child: Text(option.text),
                      style: TextButton.styleFrom(
                          backgroundColor: buttonColor(option),
                          elevation:
                              selectedOption != null && selectedOption == option
                                  ? 0
                                  : 4,
                          side:
                              selectedOption != null && selectedOption == option
                                  ? BorderSide(color: Colors.white)
                                  : BorderSide()),
                      onPressed: () => handleOptionClick(option)))
                  .toList()),
        ],
      ),
    );
  }

  Color buttonColor(Option option) {
    if (!answered) {
      return Colors.amberAccent;
    } else if (option.correct) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  void handleOptionClick(Option option) {
    setState(() {
      selectedOption = option;
      answerCorrect = option.correct;
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
        answered
            ? TextButton(
                onPressed: getNextQuestion,
                child: const Text("Next question"),
              )
            : SizedBox()
      ],
    ));
  }
}
