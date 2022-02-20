import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:genrle/components/quiz.dart';
import 'package:genrle/models/user.dart';
import 'package:genrle/redux/state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          StoreConnector<AppState, User>(
              converter: (store) => store.state.user,
              builder: (context, user) {
                return Row(
                  children: [
                    Text(
                      "${user.points} pts",
                      style:
                          TextStyle(color: Theme.of(context).primaryColorLight),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      user.username,
                      style:
                          TextStyle(color: Theme.of(context).primaryColorLight),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ],
                );
              })
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
