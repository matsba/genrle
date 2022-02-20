import 'package:genrle/models/answer.dart';
import 'package:genrle/models/option.dart';
import 'package:genrle/models/quiz_item.dart';
import 'package:genrle/models/user.dart';

class GetUserAction {
  final User user;

  GetUserAction(this.user);
}

class GetQuestionAction {
  final QuizItem quizItem;

  GetQuestionAction(this.quizItem);
}

class AnswerQustionAction {
  final Answer answer;
  final Option selectedOption;
  final User user;

  AnswerQustionAction(
      {required this.user, required this.answer, required this.selectedOption});
}
