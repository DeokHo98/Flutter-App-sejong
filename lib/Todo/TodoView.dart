import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late Database _database;
  List<Map<String, dynamic>> _todoList = [];

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todo_items(id INTEGER PRIMARY KEY, title TEXT, completed INTEGER)",
        );
      },
    );
    _getTodoList();
  }

  Future<void> _getTodoList() async {
    List<Map<String, dynamic>> list = await _database.query('todo_items');

    setState(() {
      _todoList = list;
    });
  }

  Future<void> _updateTodo(Map<String, dynamic> todo) async {
    await _database.update(
      'todo_items',
      {'completed': todo['completed'] == 1 ? 0 : 1},
      where: "id = ?",
      whereArgs: [todo['id']],
    );
    _getTodoList();
  }

  Future<void> _deleteTodo(int id) async {
    await _database.delete(
      'todo_items',
      where: "id = ?",
      whereArgs: [id],
    );
    _getTodoList();
  }

  Future<void> _addTodo(String title) async {
    await _database.insert('todo_items', {'title': title, 'completed': 0});
    _getTodoList();
  }

  void _showAddTodoDialog(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("할일 추가하기"),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "할일을 입력해주세요."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("추가"),
              onPressed: () {
                String todoText = _textFieldController.text;
                if (todoText.isNotEmpty) {
                  _addTodo(todoText);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("할일 삭제"),
          content: Text("이 할일을 삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("확인"),
              onPressed: () {
                _deleteTodo(todo['id']);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          final todo = _todoList[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Row(
                children: [
                  Expanded(child: Text(todo['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  SizedBox(
                    child: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: todo['completed'] == 1,
                        onChanged: (_) {
                          _updateTodo(todo);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              onLongPress: () {
                _showDeleteConfirmation(context, todo);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
