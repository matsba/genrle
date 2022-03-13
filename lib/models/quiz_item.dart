import 'package:genrle/models/question_image.dart';
import 'package:genrle/models/question.dart';

class QuizItem {
  String? id;
  String? created;
  QuestionImage image;
  Question question;

  QuizItem(this.image, this.question);

  QuizItem.init()
      : image = QuestionImage(src: "", title: "", subTitle: ""),
        question = Question("", []);

  //nested fromjson and tojson:
  //https://stackoverflow.com/questions/58514506/how-to-map-a-json-with-nested-objects-of-same-type-in-flutter

  QuizItem.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        created = json["created"],
        image = QuestionImage.fromJson(json['image']),
        question = Question.fromJson(json['question']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created,
      'image': image.toJson(),
      'question': question.toJson(),
    };
  }
}
