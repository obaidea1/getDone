import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getdon/layout/home_layout.dart';
import 'package:getdon/shared/bloc_observer.dart';
import 'package:getdon/shared/cubit/cubit.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const  Color.fromARGB(255, 0, 241, 12)),
        useMaterial3: true,
        textTheme: Typography.blackCupertino
      ),
      debugShowCheckedModeBanner: false,
      home:  Home(),
    );
  }
}
