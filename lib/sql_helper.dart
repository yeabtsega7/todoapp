import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper{
  static Future<void> createTable(sql.Database db)  async {
    await db.execute('CREATE TABLE todo (id INTEGER PRIMARY KEY, toDoText TEXT, isDone INTEGER)');
  }
  static Future<sql.Database> db()async{
    return sql.openDatabase(
      'todo.db',version: 1,onCreate: (sql.Database database,int v) async{
        print("create db");
        await createTable(database);
      }
    );
  }
  static Future<int> creatItem(String toDOText,int isDone) async {
    final db= await SqlHelper.db();

    final data ={ 'toDoText':toDOText,'isDone':isDone};
    print("insert to table");
    final id= await db.insert('todo', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<void> updateItem(int itemId,int isDone) async {
    final db= await SqlHelper.db();

    final data ={ 'isDone':isDone};
    print("insert to table");
    await db.update('todo', data,where: "id=?",whereArgs: [itemId],conflictAlgorithm: sql.ConflictAlgorithm.replace);

  }

  static Future<List<Map<String,dynamic>>> getItems(String search) async{
    final db=await SqlHelper.db();
    return db.query("todo",where: "toDoText >= ?",whereArgs: [search]);
  }

  static Future<void> deletItem(int id)async{
    final db=await SqlHelper.db();
    try{
      await db.delete("todo",where: "id= ?",whereArgs: [id]);
      print("deleted");
    }catch(err){
      print("error $err");
    }
  }
}