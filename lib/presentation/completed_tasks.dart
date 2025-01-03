import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_events.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_states.dart';
import 'package:simple_to_do/presentation/components/empty_widget.dart';
import 'package:simple_to_do/presentation/components/todo_checkbox.dart';

class CompletedTasks extends StatelessWidget {
  const CompletedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    final todoBloc = context.read<ToDoBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed tasks!"),
      ),
      body: BlocBuilder<ToDoBloc, ToDoState>(
        builder: (BuildContext context, ToDoState state) {
          if(state is ToDoLoaded){
            if(state.todosDone.isNotEmpty){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      bool isCompleted =
                          state.todosDone[index].isCompleted;
                      return ListTile(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text("Delete task?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            todoBloc.add(DelToDo(
                                                todo: state.todosDone[
                                                index]));
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("No")),
                                    ],
                                  );
                                });
                          },
                          title: Text(
                            state.todosDone[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          subtitle: Text(
                            state.todosDone[index].desc,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          trailing: ToDoCheckbox(
                            isCompleted: isCompleted,
                            onChanged: (bool? value) {
                              if (value != null) {
                                todoBloc.add(UpdateToDo(
                                    id: state.todosDone[index].id));
                              }
                            },
                          ));
                    },
                    separatorBuilder: (ctx, index) {
                      return Divider();
                    },
                    itemCount: state.todosDone.length),
              );
            }
            else{
              return EmptyWidget(title: "No tasks completed yet!");
            }
          }
          else{
            return EmptyWidget(title: "No tasks completed yet!");
          }
        },
      ),
    );
  }
}
