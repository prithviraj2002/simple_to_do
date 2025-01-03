import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_bloc.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_events.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_states.dart';
import 'package:simple_to_do/presentation/components/empty_widget.dart';
import 'package:simple_to_do/presentation/components/error_widget.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toDoBloc = context.read<ToDoBloc>();
    toDoBloc.add(GetPosts());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Column(
            children: [
              AppBar(
                title: Text("Posts"),
                leading: IconButton(onPressed: () {
                  toDoBloc.add(GetToDo());
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back)),
              ),
              const SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child:  SearchBar(
                  onSubmitted: (String query){
                    if(query.isNotEmpty){
                      int userId = int.parse(query);
                      toDoBloc.add(GetPosts(userId: userId));
                    }
                  },
                  leading: Icon(Icons.search),
                  hintText: "Search by user id",
                  controller: searchController,
                  onChanged: (String query){
                    if(query.isNotEmpty){
                      int userId = int.parse(query);
                      toDoBloc.add(GetPosts(userId: userId));
                    }
                  },
                ),
              )
            ],
        ),
      ),
      body: BlocConsumer<ToDoBloc, ToDoState>(
          builder: (ctx, state){
            if(state is GetPostsInitial){
              return Center(child: EmptyWidget(title: "No posts yet!",));
            }
            else if(state is GetPostsLoading){
              return const Center(child: CircularProgressIndicator());
            }
            else if(state is GetPostsLoaded){
              if(state.posts.isNotEmpty){
                return ListView.separated(
                    itemBuilder: (ctx, index){
                      return ListTile(
                        title: Text(state.posts[index].title, maxLines: 1, overflow: TextOverflow.fade,),
                        subtitle: Text(state.posts[index].body, maxLines: 1, overflow: TextOverflow.fade,),
                      );
                    },
                    separatorBuilder: (ctx, index){
                      return Divider();
                    },
                    itemCount: state.posts.length
                );
              }
              else{
                return Center(child: EmptyWidget(title: "No posts",));
              }
            }
            else if(state is GetPostsException){
              return Center(child: ErrorAsset(title: "An error occurred", desc: "Something went wrong!",));
            }
            else{
              return Container();
            }
          },
          listener: (ctx, state){
            if(state is GetPostsException){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Something went wrong")));
            }
          }
      )
    );
  }
}
