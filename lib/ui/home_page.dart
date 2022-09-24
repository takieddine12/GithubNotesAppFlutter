
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/task_controller.dart';
import 'package:notes_app/misc/app_colors.dart';
import 'package:notes_app/models/task_model.dart';
import 'package:notes_app/services/notification_services.dart';
import 'package:notes_app/services/theme_service.dart';
import 'package:notes_app/ui/add_task_page.dart';
import 'package:notes_app/ui/theme.dart';
import 'package:notes_app/widgets/task_tile.dart';

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
            const SizedBox(height: 15,),
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
               await Get.to(() => const AddTaskPage());
               _taskController.getTasks();
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
     _taskController.getTasks();
     return Expanded(
       child: Obx((){
         return ListView.builder(
           itemCount: _taskController.taskList.length,
           itemBuilder: (context,index){
             return AnimationConfiguration.staggeredList(
                 position: index,
                 child: SlideAnimation(
                   child: FadeInAnimation(
                     child: Wrap(
                       children: [
                          GestureDetector(
                            onTap: (){
                              _showBottomSheet(context,_taskController.taskList[index]);
                            },
                            child: TaskTile(_taskController.taskList[index]) ,
                          )
                       ],
                     ),
                   ),
                 )
             );
           },
         );
       }),
     );
   }
   _showBottomSheet(BuildContext context , TaskModel taskModel){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: taskModel.isCompleted == 1 ?
        MediaQuery.of(context).size.height * 0.24 :
        MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? AppColors.darkGreyColor : Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                height: 6,
                width: 120,
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[200]
                ),

              ),
            ),
            taskModel.isCompleted == 1 ? Container() :
                _showBottomSheetButton(label: 'Task Completed', onTap: (){
                  Get.back();
                }, clr: AppColors.primaryColor, context: context),
                const SizedBox(height: 10,),
                _showBottomSheetButton(label: 'Delete Task', onTap: (){
                  _taskController.deleteTask(taskModel);
                  _taskController.getTasks();
                  Get.back();
                }, clr: Colors.red[300]!, context: context),
                const SizedBox(height: 10,),
                _showBottomSheetButton(label: 'Close', onTap: (){

                }, clr: Colors.white,isClose: true, context: context)
          ],
        ),
      )
    );
   }
   _showBottomSheetButton({
     required String label ,
     required Function()? onTap ,
     required Color clr ,
     bool isClose = false,
     required BuildContext context}){
       return Padding(
         padding: const EdgeInsets.only(left: 30,right: 30),
         child: GestureDetector(
           onTap: onTap,
           child: Container(
             margin: const EdgeInsets.symmetric(vertical: 4),
             width: MediaQuery.of(context).size.width * 0.9,
             height: 55,
             decoration: BoxDecoration(
                 color: isClose == true ? Colors.white : clr,
                 border: Border.all(
                 color: isClose == true ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[500]! : clr
               ),
                 borderRadius: BorderRadius.circular(20)
             ),
             child: Center(child: Text(label,style: isClose == true ? Get.isDarkMode ? titleStyle.copyWith(color: Colors.white) : titleStyle : titleStyle.copyWith(color: Colors.white) )),
           ),
         ),
       );
   }

   void onTap(){
     print("Tapped");
     Get.to(() => const AddTaskPage());

   }
}

