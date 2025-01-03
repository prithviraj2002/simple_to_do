import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_to_do/data/endpoints.dart';
import 'package:simple_to_do/domain/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:simple_to_do/domain/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoService{

  static const _todosKey = "todos";

  Future<List<ToDoModel>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString(_todosKey);
    if (todosString == null) return [];
    final List<dynamic> jsonList = jsonDecode(todosString);
    return jsonList.map((json) => ToDoModel.fromJson(json)).toList();
  }

  Future<void> saveTodos(List<ToDoModel> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = todos.map((todo) => todo.toJson()).toList();
    await prefs.setString(_todosKey, jsonEncode(jsonList));
  }

  Future<void> addTodo(ToDoModel newTodo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? taskJson = prefs.getString(_todosKey);

    List<ToDoModel> todos = [];

    if (taskJson != null) {
      todos = (json.decode(taskJson) as List)
          .map((taskMap) => ToDoModel.fromJson(taskMap))
          .toList();
    }

    todos.add(newTodo);

    final String updatedTasksJson = json.encode(todos.map((t) => t.toJson()).toList());
    await prefs.setString(_todosKey, updatedTasksJson);
  }

  Future<void> deleteTodo(ToDoModel todo) async {
    final List<ToDoModel> todos = await loadTodos();

    todos.removeWhere((t) => t.id == todo.id);

    await saveTodos(todos);
  }

  Future<void> toggleTodoCompletion(String id) async {
    final todos = await loadTodos();

    int todoIndex = todos.indexWhere((todo) => todo.id == id);

    if (todoIndex != -1) {
      todos[todoIndex] = todos[todoIndex].copyWith(
        isCompleted: !todos[todoIndex].isCompleted,
      );

      await saveTodos(todos);
    } else {
      throw Exception("Todo with id $id not found");
    }
  }

  Future<List<PostModel>> getPosts(int? userId) async{
    List<PostModel> posts = [];
    try{

      String url = userId != null ? 'https://jsonplaceholder.typicode.com/posts?userId=$userId' : Endpoints.getPosts;

      var response = await http.get(Uri.parse(url));

      final postData = jsonDecode(response.body);

      for(Map<String, dynamic> post in postData){
        posts.add(PostModel.fromJson(post));
      }

      return posts;

    } catch(e){
      debugPrint("An exception occurred while getting posts: $e");
      throw Exception(e.toString());
    }
  }
}