import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_remake/core/bloc/bloc_exports.dart';
import 'package:spotify_remake/pages/home/home_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: Typography.whiteCupertino,
        textTheme: Typography.whiteCupertino,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: BlocProvider(
        create: (context) => ApiBloc()..add(ApiInitEvent(context: context)),
        child: const HomePage(),
      ),
    );
  }
}
