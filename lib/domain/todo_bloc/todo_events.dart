import 'package:simple_to_do/domain/models/todo_model.dart';

abstract class ToDoEvent{}

class GetToDo extends ToDoEvent{}

class GetPosts extends ToDoEvent{
  int? userId;

  GetPosts({this.userId});
}

class AddToDo extends ToDoEvent{
  ToDoModel todo;

  AddToDo({required this.todo});
}

class DelToDo extends ToDoEvent{
  ToDoModel todo;

  DelToDo({required this.todo});
}

class UpdateToDo extends ToDoEvent{
  String id;

  UpdateToDo({required this.id});
}

class SearchToDo extends ToDoEvent{
  String query;

  SearchToDo({required this.query});
}