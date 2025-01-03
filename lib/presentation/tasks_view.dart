import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_events.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_states.dart';
import 'package:simple_to_do/presentation/add_task_view.dart';
import 'package:simple_to_do/presentation/completed_tasks.dart';
import 'package:simple_to_do/presentation/components/completed_widget.dart';
import 'package:simple_to_do/presentation/components/empty_widget.dart';
import 'package:simple_to_do/presentation/components/error_widget.dart';
import 'package:simple_to_do/presentation/components/title_chip.dart';
import 'package:simple_to_do/presentation/components/todo_checkbox.dart';
import 'package:simple_to_do/presentation/post_view.dart';
import 'package:simple_to_do/presentation/view_all_tasks.dart';

class UserTaskView extends StatelessWidget {
  const UserTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final todoBloc = context.read<ToDoBloc>();
    todoBloc.add(GetToDo());
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => BlocProvider.value(
                              value: todoBloc,
                              child: PostsView(),
                            )));
              },
              child: Text("Check Posts"))
        ],
      ),
      body: BlocConsumer<ToDoBloc, ToDoState>(builder: (ctx, state) {
        if (state is ToDoInitial) {
          return Center(
              child: EmptyWidget(
            title: "Start adding tasks",
          ));
        }
        else if (state is ToDoLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (state is ToDoException) {
          return Center(
              child: ErrorAsset(
            title: "An error occurred",
            desc: "Something went wrong!",
          ));
        }
        else if (state is ToDoLoaded) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.42,
                          top: MediaQuery.of(context).size.height * 0.12,
                          child: Text("${state.todosDone.length} / ${state.todos.length + state.todosDone.length}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                      ),
                      SizedBox(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: PieChart(
                          duration: Duration(milliseconds: 150),
                          curve: Curves.linear,
                        PieChartData(
                          centerSpaceRadius: double.infinity,
                          sections: [
                            PieChartSectionData(
                              value: double.parse(state.todosDone.length.toString()),
                              color: Colors.deepPurple,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: double.parse(state.todos.length.toString()),
                              color: Colors.black12
                            )
                          ]
                        )
                      ),
                    ),
                    ]
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.deepPurple,)
                        ),
                        height: 75,
                        child: Column(
                            children: [
                              Text("Tasks Done", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 20),),
                              Expanded(child: Container(),),
                              Text("${state.todosDone.length}", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 24),)
                            ]
                        ),
                      ),
                      const SizedBox(width: 12,),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.deepPurple,
                        ),
                        height: 75,
                        child: Column(
                            children: [
                              Text("Tasks Pending", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                              Expanded(child: Container(),),
                              Text("${state.todos.length}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),)
                            ]
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  state.todos.isNotEmpty ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleChip(title: "On going tasks"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(value: todoBloc, child: ViewAllTasks(),)));
                          },
                          child: Text("View all"))
                    ],
                  ) : Container(),
                  const SizedBox(
                    height: 12,
                  ),
                  state.todos.isNotEmpty ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          bool isCompleted = state.todos[index].isCompleted;
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
                                                    todo: state.todos[index]));
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
                                    todoBloc.add(
                                        UpdateToDo(id: state.todos[index].id));
                                  }
                                },
                              ));
                        },
                        separatorBuilder: (ctx, index) {
                          return Divider();
                        },
                        itemCount: state.todos.length),
                  ) : CompletedWidget(title: "Wohoo all tasks completed!",),
                  state.todosDone.isNotEmpty ? ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(value: todoBloc, child: CompletedTasks())));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("View completed tasks!")
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ) : Container()
                  // todoBloc.todosDone.isNotEmpty
                  //     ? TitleChip(title: "Completed")
                  //     : Container(),
                  // todoBloc.todosDone.isNotEmpty
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ListView.separated(
                  //             shrinkWrap: true,
                  //             itemBuilder: (ctx, index) {
                  //               bool isCompleted =
                  //                   state.todosDone[index].isCompleted;
                  //               return ListTile(
                  //                   onLongPress: () {
                  //                     showDialog(
                  //                         context: context,
                  //                         builder: (ctx) {
                  //                           return AlertDialog(
                  //                             title: Text("Delete task?"),
                  //                             actions: [
                  //                               TextButton(
                  //                                   onPressed: () {
                  //                                     todoBloc.add(DelToDo(
                  //                                         todo: state.todosDone[
                  //                                             index]));
                  //                                     Navigator.pop(context);
                  //                                   },
                  //                                   child: Text("Yes")),
                  //                               TextButton(
                  //                                   onPressed: () {
                  //                                     Navigator.pop(context);
                  //                                   },
                  //                                   child: Text("No")),
                  //                             ],
                  //                           );
                  //                         });
                  //                   },
                  //                   title: Text(
                  //                     state.todosDone[index].title,
                  //                     maxLines: 1,
                  //                     overflow: TextOverflow.fade,
                  //                   ),
                  //                   subtitle: Text(
                  //                     state.todosDone[index].desc,
                  //                     maxLines: 1,
                  //                     overflow: TextOverflow.fade,
                  //                   ),
                  //                   trailing: ToDoCheckbox(
                  //                     isCompleted: isCompleted,
                  //                     onChanged: (bool? value) {
                  //                       if (value != null) {
                  //                         todoBloc.add(UpdateToDo(
                  //                             id: state.todosDone[index].id));
                  //                       }
                  //                     },
                  //                   ));
                  //             },
                  //             separatorBuilder: (ctx, index) {
                  //               return Divider();
                  //             },
                  //             itemCount: state.todosDone.length),
                  //       )
                  //     : Container(),
                ],
              ),
            ),
          );
        } 
        else {
          return Container();
        }
      }, listener: (ctx, state) {
        if (state is ToDoException) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong")));
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => BlocProvider.value(
                        value: todoBloc,
                        child: AddTaskView(),
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
