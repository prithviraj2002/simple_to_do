import 'package:flutter/material.dart';
import 'package:simple_to_do/data/repo/todo_repo.dart';
import 'package:simple_to_do/data/service/todo_service.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/presentation/tasks_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (BuildContext context) => ToDoBloc(repo: ToDoRepo(service: ToDoService()))),
          ],
          child: UserTaskView()
      ),
    );
  }
}
