import 'package:simple_to_do/data/repo/todo_repo.dart';
import 'package:simple_to_do/domain/models/post_model.dart';
import 'package:simple_to_do/domain/models/todo_model.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_events.dart';
import 'package:simple_to_do/domain/todo_bloc/todo_states.dart';
import 'package:bloc/bloc.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState>{
  ToDoRepo repo;
  List<ToDoModel> todos = [];
  List<ToDoModel> todosDone = [];

  ToDoBloc({required this.repo}): super(ToDoInitial()){

    on<GetPosts>((event, emit) async{
      emit(GetPostsLoading());

      try{
        List<PostModel> posts = await repo.getPosts(event.userId);

        emit(GetPostsLoaded(posts: posts));
      }
      catch(e){
        emit(GetPostsException(errorMessage: e.toString()));
      }
    });

    on<GetToDo>((event, emit) async{
      emit(ToDoLoading());

      try{
        List<ToDoModel> tasks = await repo.getToDos();
        // todos = tasks;

        todos = []; todosDone = [];
        for(ToDoModel todo in tasks){
          if(todo.isCompleted){
            todosDone.add(todo);
          }
          else{
            todos.add(todo);
          }
        }

        emit(ToDoLoaded(todos: todos, todosDone: todosDone));
      }
      catch(e){
        emit(ToDoException(errorMessage: e.toString()));
      }
    });

    on<AddToDo>((event, emit) async{
      todos.add(event.todo);
      await repo.addToDo(event.todo);
      emit(ToDoLoaded(todos: todos, todosDone: todosDone));
    });

    on<DelToDo>((event, emit) async{
      if(todos.contains(event.todo)){
        todos.remove(event.todo);
      }

      if(todosDone.contains(event.todo)){
        todosDone.remove(event.todo);
      }
      await repo.delToDo(event.todo);

      emit(ToDoLoaded(todos: todos, todosDone: todosDone));
    });

    on<UpdateToDo>((event, emit) async {
      await repo.toggleTodoCompletion(event.id);
      List<ToDoModel> updatedToDo = await repo.getToDos();
      // todos = updatedToDo;

      todos = []; todosDone = [];
      for(ToDoModel todo in updatedToDo){
        if(todo.isCompleted){
          todosDone.add(todo);
        }
        else{
          todos.add(todo);
        }
      }

      emit(ToDoLoaded(todos: todos, todosDone: todosDone));
    });

    on<SearchToDo>((event, emit) {
      String search = event.query;

      List<ToDoModel> searchTodos = [];

      for(ToDoModel todo in todos){
        if(todo.title.contains(search)){
          searchTodos.add(todo);
        }
      }

      emit(SearchResultToDo(todos: searchTodos));
    });
  }
}