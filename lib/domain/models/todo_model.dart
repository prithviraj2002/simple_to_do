class ToDoModel{
  final String id;
  final String title;
  final String desc;
  bool isCompleted;

  ToDoModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.isCompleted
  });

  ToDoModel copyWith({
    String? id,
    String? title,
    String? desc,
    bool? isCompleted,
  }) {
    return ToDoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory ToDoModel.fromJson(Map<String, dynamic> json){
    return ToDoModel(id: json['id'], title: json['title'], desc: json['desc'], isCompleted: json['isCompleted']);
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'isCompleted': isCompleted
    };
  }
}