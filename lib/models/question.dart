import 'option.dart';

class Question {
  final String text;
  final List<Option> options;

  Question(this.text, this.options);

  Question.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        options =
            List<Option>.from(json['options'].map((x) => Option.fromJson(x)));

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'options': List<dynamic>.from(options.map((x) => x.toJson())),
    };
  }
}
