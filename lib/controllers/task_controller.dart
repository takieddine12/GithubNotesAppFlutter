


import 'package:get/get.dart';
import 'package:notes_app/db/db_helper.dart';
import 'package:notes_app/models/task_model.dart';

class TaskController extends GetxController {


  Future<int> insertTask(TaskModel taskModel) async {
    return await DbHelper.insertTask(taskModel);
  }
}