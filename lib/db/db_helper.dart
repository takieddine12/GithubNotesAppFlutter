
import 'package:get/get.dart';
import 'package:notes_app/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "task";

  static Future<void> initDB() async {
    if(_db != null){
      return;
    }
    try {
      String path = "${await getDatabasesPath()}tasks.db";
      _db = await openDatabase(
          path,
          version: _version,
          onCreate: (db,version){
            return db.execute(
              'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, note TEXT, date TEXT, startTime TEXT, endTime TEXT, remind INTEGER, repeat TEXT, color INTEGER, isCompleted INTEGER)',
            );
          }
      );
    } catch(e){
      print("Exception Caught");
    }

  }

  static Future<int> insertTask(TaskModel taskModel) async {
    return _db!.insert(_tableName, taskModel.toJson());
  }
}

