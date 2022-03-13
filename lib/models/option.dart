class Option {
  String text;
  bool correct;

  Option(this.text, {this.correct = false});

  Option.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        correct = json['correct'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'correct': correct,
    };
  }
}
