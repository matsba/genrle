import 'package:genreguesser/models/option.dart';
import 'package:genreguesser/models/question_image.dart';
import 'package:genreguesser/models/question.dart';
import 'package:genreguesser/models/quiz_item.dart';

class QuizService {
  int lastReturnedMockIndex = 0;

  List<QuizItem> quizItems = [
    QuizItem(
      QuestionImage(
          src: "https://f4.bcbits.com/img/a3622621927_9.jpg",
          title: "Moksha",
          subTitle: "THE LAST OF LUCY"),
      Question("Whats the genre?", [
        Option("Pop"),
        Option("Technical Death Metal", correct: true),
        Option("Rock")
      ]),
    ),
    QuizItem(
      QuestionImage(
          src: "https://f4.bcbits.com/img/a0647674605_9.jpg",
          title: "Converge",
          subTitle: "The Poacher Diaries Redux"),
      Question("This band is from USA. Whats the genre?", [
        Option("Post-Hardcore", correct: true),
        Option("Technical Death Metal"),
        Option("J-POP")
      ]),
    )
  ];
  QuizItem get() {
    if (lastReturnedMockIndex > quizItems.length - 1) lastReturnedMockIndex = 0;
    return quizItems[lastReturnedMockIndex++];
  }
}
