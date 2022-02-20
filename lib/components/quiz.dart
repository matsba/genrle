import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:genrle/models/answer.dart';
import 'package:genrle/models/option.dart';
import 'package:genrle/models/question.dart';
import 'package:genrle/models/question_image.dart';
import 'package:genrle/models/quiz_item.dart';
import 'package:genrle/redux/middleware.dart';
import 'package:genrle/redux/state.dart';

class Quiz extends StatelessWidget {
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

  Widget _optionButton(Option option) {
    Color buttonColor(
      Answer answer,
    ) {
      if (answer == Answer.NotAnswered) {
        return Colors.amberAccent;
      } else if (option.correct) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }

    return StoreConnector<AppState, _OptionButtonViewModel>(
        converter: (store) => _OptionButtonViewModel(
            selectedOption: store.state.selectedOption,
            answer: store.state.answer,
            answerQuestion: (value) => store.dispatch(answerQuestion(value))),
        builder: (context, vm) {
          return TextButton(
              child: Text(option.text),
              style: TextButton.styleFrom(
                backgroundColor: buttonColor(vm.answer),
              ),
              onPressed: () => vm.answerQuestion(option));
        });
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
                  .map((option) => _optionButton(option))
                  .toList()),
        ],
      ),
    );
  }

  Widget quizItemDisplay(QuizItem item) {
    return Column(
        children: [quizImage(item.image), quizQuestion(item.question)]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StoreConnector<AppState, _QuizViewModel>(
          converter: (store) => _QuizViewModel(
                answer: store.state.answer,
                quizItem: store.state.quizItem,
                getNextQuestion: () => store.dispatch(getQuestion()),
              ),
          builder: (context, vm) {
            return Column(
              children: [
                quizItemDisplay(vm.quizItem),
                vm.answer != Answer.NotAnswered
                    ? TextButton(
                        onPressed: vm.getNextQuestion,
                        child: const Text("Next question"),
                      )
                    : SizedBox()
              ],
            );
          }),
    );
  }
}

class _OptionButtonViewModel {
  Option? selectedOption;
  Answer answer;
  final void Function(Option) answerQuestion;

  _OptionButtonViewModel(
      {required this.selectedOption,
      required this.answerQuestion,
      required this.answer});
}

class _QuizViewModel {
  QuizItem quizItem;
  Answer answer;
  final void Function() getNextQuestion;

  _QuizViewModel(
      {required this.quizItem,
      required this.answer,
      required this.getNextQuestion});
}
