import 'package:genreguesser/models/question_image.dart';
import 'package:genreguesser/models/question.dart';

class QuizItem {
  QuestionImage image;
  Question question;

  QuizItem(this.image, this.question);

  QuizItem.init()
      : image = QuestionImage(src: "", title: "", subTitle: ""),
        question = Question("", []);
}
