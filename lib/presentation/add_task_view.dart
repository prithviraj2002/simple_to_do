import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/domain/models/todo_model.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_events.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toDoBloc = context.read<ToDoBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add task"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                maxLines: 1,
                validator: (String? value){
                  if(value == null || value.isEmpty){
                    return "Title is empty!";
                  }
                  return null;
                },
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 12,),
              TextFormField(
                maxLines: null,
                validator: (String? value){
                  if(value == null || value.isEmpty){
                    return "Description is empty!";
                  }
                  return null;
                },
                controller: descController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Description",
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(formKey.currentState!.validate()){
            ToDoModel todo = ToDoModel(
                id: DateTime.now().toString(),
                title: titleController.text.trim(),
                desc: descController.text.trim(),
                isCompleted: false
            );
            toDoBloc.add(AddToDo(todo: todo));
            Navigator.pop(context);
          }
        },
        child: Text("Save"),
      ),
    );
  }
}
