class ToDo {
  int id;
  String toDoText;
  bool isDone;

  ToDo({required this.id, required this.toDoText, required this.isDone});
  static List<ToDo> todolists(){
    return [
      ToDo(id: 1, toDoText: "ertyui", isDone: false),
    ];
  }
}
