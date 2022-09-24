


import 'package:get/get.dart';
import 'package:notes_app/db/db_helper.dart';
import 'package:notes_app/models/task_model.dart';

class TaskController extends GetxController {

   RxList<TaskModel> taskList =  <TaskModel>[].obs;


   @override
   void onReady(){
     super.onReady();
     getTasks();
   }

  Future<int> insertTask(TaskModel taskModel) async {
    return await DbHelper.insertTask(taskModel);
  }

  Future getTasks() async {
    List<Map<String,dynamic>> mapList = await DbHelper.query();
    taskList.assignAll(mapList.map((data) => TaskModel.fromJson(data)).toList());

  }

  Future<int> deleteTask(TaskModel taskModel) async {
     return await DbHelper.delete(taskModel);
  }
}