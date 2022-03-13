class QuestionImage {
  final String src;
  final String title;
  final String subTitle;

  QuestionImage(
      {required this.src, required this.title, required this.subTitle});

  QuestionImage.fromJson(Map<String, dynamic> json)
      : src = json['src'],
        subTitle = json['subTitle'],
        title = json['title'];

  Map<String, dynamic> toJson() {
    return {
      'src': src,
      'subTitle': subTitle,
      'title': title,
    };
  }
}
