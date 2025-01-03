import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_events.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_states.dart';
import 'package:simple_to_do/presentation/components/empty_widget.dart';
import 'package:simple_to_do/presentation/components/error_widget.dart';
import 'package:simple_to_do/presentation/components/todo_checkbox.dart';

class ViewAllTasks extends StatefulWidget {
  const ViewAllTasks({super.key});

  @override
  State<ViewAllTasks> createState() => _ViewAllTasksState();
}

class _ViewAllTasksState extends State<ViewAllTasks> {

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoBloc = context.read<ToDoBloc>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Column(
          children: [
            AppBar(
              title: Text("Ongoing tasks"),
              leading: IconButton(onPressed: () {
                todoBloc.add(GetToDo());
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back)),
            ),
            const SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child:  SearchBar(
                onSubmitted: (String query){
                  if(query.isNotEmpty && todoBloc.todos.isNotEmpty){
                    todoBloc.add(SearchToDo(query: query));
                  }
                },
                leading: Icon(Icons.search),
                hintText: "Search by title",
                controller: searchController,
                onChanged: (String query){
                  if(query.isNotEmpty && todoBloc.todos.isNotEmpty){
                    todoBloc.add(SearchToDo(query: query));
                  }
                },
              ),
            )
          ],
        ),
      ),
      body: BlocBuilder<ToDoBloc, ToDoState>(
        builder: (BuildContext context, ToDoState state) {
          if(state is ToDoLoaded){
            if(state.todos.isNotEmpty){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      bool isCompleted =
                          state.todos[index].isCompleted;
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
                                                todo: state.todos[
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
                            state.todos[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          subtitle: Text(
                            state.todos[index].desc,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          trailing: ToDoCheckbox(
                            isCompleted: isCompleted,
                            onChanged: (bool? value) {
                              if (value != null) {
                                todoBloc.add(UpdateToDo(
                                    id: state.todos[index].id));
                              }
                            },
                          ));
                    },
                    separatorBuilder: (ctx, index) {
                      return Divider();
                    },
                    itemCount: state.todos.length),
              );
            }
            else{
              return EmptyWidget(title: "No ongoing tasks!");
            }
          }
          else if(state is SearchResultToDo){
            if(state.todos.isNotEmpty){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      bool isCompleted =
                          state.todos[index].isCompleted;
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
                                                todo: state.todos[
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
                            state.todos[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          subtitle: Text(
                            state.todos[index].desc,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          trailing: ToDoCheckbox(
                            isCompleted: isCompleted,
                            onChanged: (bool? value) {
                              if (value != null) {
                                todoBloc.add(UpdateToDo(
                                    id: state.todos[index].id));
                              }
                            },
                          ));
                    },
                    separatorBuilder: (ctx, index) {
                      return Divider();
                    },
                    itemCount: state.todos.length),
              );
            }
            else{
              return ErrorAsset(title: "No task found!",);
            }
          }
          else{
            return EmptyWidget(title: "No ongoing tasks!");
          }
        },
      ),
    );
  }
}
