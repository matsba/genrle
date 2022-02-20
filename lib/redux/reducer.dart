import 'package:flutter/cupertino.dart';
import 'package:genrle/models/answer.dart';
import 'package:genrle/redux/actions.dart';
import 'package:genrle/redux/state.dart';

AppState reducer(AppState state, dynamic action) {
  if (action is GetUserAction) {
    return AppState(
        user: action.user, quizItem: state.quizItem, answer: state.answer);
  }

  if (action is GetQuestionAction) {
    return AppState(
        user: state.user,
        quizItem: action.quizItem,
        answer: Answer.NotAnswered);
  }

  if (action is AnswerQustionAction) {
    return AppState(
        user: action.user, quizItem: state.quizItem, answer: action.answer);
  }

  return state;
}
