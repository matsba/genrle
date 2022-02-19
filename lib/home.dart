import 'package:flutter/material.dart';
import 'package:genreguesser/components/quiz.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Text("user#1234"),
              Icon(Icons.account_circle),
            ],
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Quiz(),
      ),
    );
  }
}
