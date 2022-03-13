import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:genrle/models/option.dart';
import 'package:genrle/models/question.dart';
import 'package:genrle/models/question_image.dart';
import "package:genrle/models/quiz_item.dart";
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genrle Admin Tool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Genrle Admin Tool'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  List<QuizItem> quizItems = [];
  int? countOfQuizItemsInDatabase;

  final TextEditingController _questionImageSrcController =
      TextEditingController();
  final TextEditingController _questionImageTitleController =
      TextEditingController();
  final TextEditingController _questionImageSubTitleController =
      TextEditingController();
  final TextEditingController _questionTextController = TextEditingController();

  final TextEditingController _questionOption1TextController =
      TextEditingController();
  final TextEditingController _questionOption2TextController =
      TextEditingController();
  final TextEditingController _questionOption3TextController =
      TextEditingController();

  bool _questionOption1Correct = false;
  bool _questionOption2Correct = false;
  bool _questionOption3Correct = false;

  void initState() {
    super.initState();
    _getQuizItems();
  }

  Future<void> _getQuizItems() async {
    var headers = {"Content-Type": "application/json", "x-api-key": "salainen"};

    var requestUrl = Uri(host: "localhost", port: 3000, path: "/dev/quiz");

    var response = await get(requestUrl, headers: headers);

    var count = jsonDecode(response.body)["count"];
    List<QuizItem> items = List<QuizItem>.from(
        jsonDecode(response.body)["quizItems"]
            .map((x) => QuizItem.fromJson(x)));

    setState(() {
      quizItems = items;
      countOfQuizItemsInDatabase = count;
    });
  }

  Future<void> _submitForm() async {
    var questionImage = QuestionImage(
        src: _questionImageSrcController.text,
        title: _questionImageTitleController.text,
        subTitle: _questionImageSubTitleController.text);
    var option1 = Option(_questionOption1TextController.text,
        correct: _questionOption1Correct);
    var option2 = Option(_questionOption2TextController.text,
        correct: _questionOption2Correct);
    var option3 = Option(_questionOption3TextController.text,
        correct: _questionOption3Correct);
    var question =
        Question(_questionTextController.text, [option1, option2, option3]);

    var quizItem = QuizItem(questionImage, question);

    //TODO: replace api kay with env variable
    var headers = {"Content-Type": "application/json", "x-api-key": "salainen"};

    //TODO: Replace localhost with env variable
    var requestUrl =
        Uri(host: "localhost", port: 3000, path: "/dev/quiz/create");
    await post(requestUrl, body: jsonEncode(quizItem), headers: headers);
    await _getQuizItems();
  }

  String? _textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  Widget _basicTextField(
      {required String label, TextEditingController? controller}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: _textValidator,
      controller: controller ?? TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Question image",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          _basicTextField(
                              label: 'Url',
                              controller: _questionImageSrcController),
                          _basicTextField(
                              label: 'Title',
                              controller: _questionImageTitleController),
                          _basicTextField(
                              label: 'Subtitle',
                              controller: _questionImageSubTitleController),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Question",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          _basicTextField(
                              label: 'Text',
                              controller: _questionTextController),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text("Options",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Table(
                            children: [
                              const TableRow(children: [
                                const Center(child: Text("Option text")),
                                const Center(child: Text("Correct?"))
                              ]),
                              TableRow(children: [
                                _basicTextField(
                                    label: 'Option 1',
                                    controller: _questionOption1TextController),
                                Checkbox(
                                  value: _questionOption1Correct,
                                  onChanged: (value) {
                                    setState(() {
                                      _questionOption1Correct = value ?? false;
                                    });
                                  },
                                ),
                              ]),
                              TableRow(children: [
                                _basicTextField(
                                    label: 'Option 2',
                                    controller: _questionOption2TextController),
                                Checkbox(
                                  value: _questionOption2Correct,
                                  onChanged: (value) {
                                    setState(() {
                                      _questionOption2Correct = value ?? false;
                                    });
                                  },
                                )
                              ]),
                              TableRow(children: [
                                _basicTextField(
                                    label: 'Option 3',
                                    controller: _questionOption3TextController),
                                Checkbox(
                                  value: _questionOption3Correct,
                                  onChanged: (value) {
                                    setState(() {
                                      _questionOption3Correct = value ?? false;
                                    });
                                  },
                                )
                              ])
                            ],
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          ElevatedButton(
                              onPressed: _submitForm,
                              child: const Text("Create"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                      "Quiz items in database ${countOfQuizItemsInDatabase != null ? countOfQuizItemsInDatabase : ''}"),
                  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: quizItems.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(children: [
                          Text("id: ${quizItems[index].id.toString()}"),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                                "${quizItems[index].image.title} - ${quizItems[index].question.text}"),
                          ),
                        ]);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
