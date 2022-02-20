import 'package:genrle/models/answer.dart';
import 'package:genrle/models/option.dart';
import 'package:genrle/redux/actions.dart';
import 'package:genrle/redux/state.dart';
import 'package:genrle/services/quiz_service.dart';
import 'package:genrle/services/user_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

UserService _userService = UserService();
QuizService _quizService = QuizService();

ThunkAction<AppState> getUser() {
  return (Store<AppState> store) async {
    var user = await _userService.get();

    store.dispatch(GetUserAction(user));
  };
}

ThunkAction<AppState> answerQuestion(Option option) {
  return (Store<AppState> store) async {
    if (option.correct) {
      await _userService.incrementPointsBy(2);
    }

    var user = await _userService.get();

    store.dispatch(AnswerQustionAction(
        user: user,
        answer: option.correct ? Answer.Correct : Answer.Incorrect,
        selectedOption: option));
  };
}

ThunkAction<AppState> getQuestion() {
  return (Store<AppState> store) async {
    var quizItem = _quizService.get();

    store.dispatch(GetQuestionAction(quizItem));
  };
}
