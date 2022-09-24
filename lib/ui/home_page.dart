
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/task_controller.dart';
import 'package:notes_app/misc/app_colors.dart';
import 'package:notes_app/services/notification_services.dart';
import 'package:notes_app/services/theme_service.dart';
import 'package:notes_app/ui/add_task_page.dart';
import 'package:notes_app/ui/theme.dart';

import '../widgets/my_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   DateTime _dateTime = DateTime.now();
  late NotificationHelper notificationHelper;
  final TaskController _taskController = Get.put(TaskController());
  @override
  void initState() {
    super.initState();
    notificationHelper = NotificationHelper();
    notificationHelper.initializeNotification();
    notificationHelper.requestIOSPermissions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            _dateBar(),
            _taskBar(),
            _showTasks(),
          ],
        ),
      ),
    );
  }

   _appBar(){
     return AppBar(
       elevation: 0,
       backgroundColor: context.theme.backgroundColor,
       leading: GestureDetector(
         onTap: (){
           // Switch App Theme
           ThemeService().switchTheme();
           // Display Notification To User
           notificationHelper.displayNotification(
               title: 'Simple Notification',
               body: Get.isDarkMode ? 'Activated Dark Mode' : 'Activated Light Mode');
           // Schedule Notification For Certain interval To Show
           //notificationHelper.scheduledNotification();
         },
         child:  Icon(
           Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
           size: 20,
           color: Get.isDarkMode ? Colors.white : Colors.black,),
       ),
       actions:  const [
         Padding(
           padding: EdgeInsets.only(right: 10),
           child: CircleAvatar(
             backgroundImage : AssetImage('assets/images/profile_pic.png',),
           ),
         )
       ],
     );
   }
   _dateBar(){
     return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(DateFormat.yMMMMd().format(DateTime.now()),style: subHeaderStyle,),
             Text('Today',style: headingStyle,)
           ],
         ),
         GestureDetector(
             onTap: () async {
               Get.to(() => const AddTaskPage());
               await _taskController.getTasks();
             },
             child: MyButton(label: '+ Add Task'))
       ],
     );
   }
   _taskBar(){
     return Container(
       margin: const EdgeInsets.only(top: 20),
       child: DatePicker(
         DateTime.now(),
         height: 100,
         width: 80,
         initialSelectedDate: DateTime.now(),
         selectionColor: AppColors.bluishColor,
         selectedTextColor: Colors.white,
         dateTextStyle: GoogleFonts.lato(
             textStyle: const TextStyle(
                 fontSize: 17,
                 fontWeight: FontWeight.w600
             )
         ),
         dayTextStyle: GoogleFonts.lato(
             textStyle: const TextStyle(
                 fontSize: 17,
                 fontWeight: FontWeight.w600
             )
         ),
         monthTextStyle: GoogleFonts.lato(
             textStyle: const TextStyle(
                 fontSize: 17,
                 fontWeight: FontWeight.w600
             )
         ),
         onDateChange: (date){
           setState(() {
             _dateTime = date;
           });
         },
       ),
     );
   }
   _showTasks(){
     return Expanded(
       child: Obx((){
         return ListView.builder(
           itemCount: _taskController.taskList.length,
           itemBuilder: (context,index){
             return GestureDetector(
               onTap: () async {
                 int result = await _taskController.deleteTask(_taskController.taskList[index]);
                 if(result == 1){
                   _taskController.getTasks();
                 }

               },
               child: Container(
                 width: 300,
                 height: 30,
                 color: Colors.red,
                 margin: const EdgeInsets.only(bottom: 10),
                 child: Column(
                   children: [
                     Text(_taskController.taskList[index].title!)
                   ],
                 ),
               ),
             );
           },
         );
       }),
     );
   }

   void onTap(){
     print("Tapped");
     Get.to(() => const AddTaskPage());

   }
}

