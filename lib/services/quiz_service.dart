import 'package:genrle/models/option.dart';
import 'package:genrle/models/question_image.dart';
import 'package:genrle/models/question.dart';
import 'package:genrle/models/quiz_item.dart';
import 'package:genrle/services/user_service.dart';
import 'package:genrle/util/http_service.dart';

class QuizService {
  int lastReturnedMockIndex = 0;
  UserService _userService = UserService();
  HttpService httpClient = HttpService();

  List<QuizItem> quizItems = [
    QuizItem(
      QuestionImage(
          src: "https://www.metal-archives.com/images/9/9/3/3/993371.jpg?3311",
          title: "THE LAST OF LUCY",
          subTitle: "Moksha"),
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
        Option("Surf Rock"),
        Option("J-POP")
      ]),
    )
  ];
  QuizItem get() {
    if (lastReturnedMockIndex > quizItems.length - 1) lastReturnedMockIndex = 0;
    return quizItems[lastReturnedMockIndex++];
  }

  Future<void> answer() async {
    await _userService.incrementPoints(httpClient);
  }
}
