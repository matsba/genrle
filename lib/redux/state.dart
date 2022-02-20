import 'package:genrle/models/answer.dart';
import 'package:genrle/models/option.dart';
import 'package:genrle/models/quiz_item.dart';
import 'package:genrle/models/user.dart';

class AppState {
  final User user;
  final QuizItem quizItem;
  final Answer answer;
  Option? selectedOption;

  AppState(
      {required this.user,
      required this.quizItem,
      required this.answer,
      this.selectedOption});

  AppState.init()
      : user = User.init(),
        quizItem = QuizItem.init(),
        answer = Answer.NotAnswered,
        selectedOption = null;
}
