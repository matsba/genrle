import 'package:genrle/models/question_image.dart';
import 'package:genrle/models/question.dart';

class QuizItem {
  QuestionImage image;
  Question question;

  QuizItem(this.image, this.question);

  QuizItem.init()
      : image = QuestionImage(src: "", title: "", subTitle: ""),
        question = Question("", []);
}
