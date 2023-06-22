import 'package:flutter/material.dart';
import 'package:todo/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      home: const MyHomePage(title: 'To Do App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchValue = "";
  List<Map<String,dynamic>> todo=[

  ];
  void load() async{
    final data=await SqlHelper.getItems(searchValue);
    print("search $searchValue");
    setState(() {
      todo =data;
    });
  }
  @override
  void initState() {
    super.initState();
    load();
  }
  @override
  Widget build(BuildContext context) {
    print("number of items ${todo}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey.shade400,
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: ListView(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search"),
                  onChanged: (v) {
                    setState(() {
                      searchValue = v;
                      load();
                      print(searchValue);
                    });
                  },
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "All To Dos",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 210,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for(Map<String, dynamic> to in todo)
                            todoListCard(to,(v) async {
                              load();
                              setState(() {

                              });
                            }),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewToDo();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> addNewToDo() async {
    final todoText=TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add New TODO"),
            content: TextField(
              controller: todoText,
              maxLines: 5,
              minLines: 1,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(hintText: "TODO"),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.grey,
                textColor: Colors.white,
                child: const Text('cancel'),
              ),
              MaterialButton(
                onPressed: () async {
                  int a=await SqlHelper.creatItem(todoText.text, 0);
                  print("insert id $a");
                  load();
                  setState(() {

                  });
                  Navigator.pop(context);
                },
                color: Colors.green,
                child: const Text("Add"),
                textColor: Colors.white,
              )
            ],
          );
        });
  }
}

class todoListCard extends StatefulWidget {
  Map<String ,dynamic> todo;
  ValueChanged<bool> ondelete;
  todoListCard(this.todo,this.ondelete,{Key? key}) : super(key: key);

  @override
  State<todoListCard> createState() => _todoListCardState();
}

class _todoListCardState extends State<todoListCard> {
  bool check = false;
  @override
  void initState() {
    // TODO: implement initState
    check=widget.todo['isDone']==0?false:true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          Checkbox(
              value: check,
              onChanged: (v) async {
                  check = v!;
                  await SqlHelper.updateItem(widget.todo['id'], check?1:0);
                setState(() {
                });
              }),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.todo['toDoText'],
                  style: TextStyle(
                      decoration: check
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 15),
                ),
                IconButton(
                    onPressed: () async {
                      print("delete todo");
                      await SqlHelper.deletItem(widget.todo['id']);
                      setState(() {
                        widget.ondelete.call(false);
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
