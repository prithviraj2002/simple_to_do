import 'package:simple_to_do/domain/models/post_model.dart';
import 'package:simple_to_do/domain/models/todo_model.dart';

abstract class ToDoState{}

class ToDoInitial extends ToDoState{}

class ToDoLoading extends ToDoState{}

class ToDoLoaded extends ToDoState{
  List<ToDoModel> todos; List<ToDoModel> todosDone = [];

  ToDoLoaded({required this.todos, required this.todosDone});
}

class ToDoException extends ToDoState{
  final String errorMessage;

  ToDoException({required this.errorMessage});
}

class SearchResultToDo extends ToDoState{
  List<ToDoModel> todos;

  SearchResultToDo({required this.todos});
}

class GetPostsInitial extends ToDoState{}

class GetPostsLoading extends ToDoState{}

class GetPostsLoaded extends ToDoState{
  List<PostModel> posts;

  GetPostsLoaded({required this.posts});
}

class GetPostsException extends ToDoState{
  final String errorMessage;

  GetPostsException({required this.errorMessage});
}