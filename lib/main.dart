import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:genrle/home.dart';
import 'package:genrle/redux/middleware.dart';
import 'package:genrle/redux/reducer.dart';
import 'package:genrle/redux/state.dart';
import 'package:genrle/theme.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final store = Store<AppState>(reducer,
      initialState: AppState.init(), middleware: [thunkMiddleware]);

  @override
  Widget build(BuildContext context) {
    store.dispatch(getUser());
    store.dispatch(getQuestion());

    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Genrle',
          theme: GlobalTheme().globalTheme,
          home: HomePage(),
        ));
  }
}
