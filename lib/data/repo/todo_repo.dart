import 'package:simple_to_do/data/service/todo_service.dart';
import 'package:simple_to_do/domain/models/post_model.dart';

import '../../domain/models/todo_model.dart';

class ToDoRepo{
  ToDoService service;

  ToDoRepo({required this.service});

  Future<List<PostModel>> getPosts(int? userId) => service.getPosts(userId);

  Future<void> saveTodos(List<ToDoModel> todos) => service.saveTodos(todos);

  Future<void> addToDo(ToDoModel todo) => service.addTodo(todo);

  Future<void> delToDo(ToDoModel todo) => service.deleteTodo(todo);

  Future<void> toggleTodoCompletion(String id) => service.toggleTodoCompletion(id);

  Future<List<ToDoModel>> getToDos() => service.loadTodos();
}