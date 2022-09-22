
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/misc/app_colors.dart';
import 'package:notes_app/services/notification_services.dart';
import 'package:notes_app/services/theme_service.dart';
import 'package:notes_app/ui/theme.dart';

import '../widgets/my_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotificationHelper notificationHelper;
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
      appBar: _appBar(),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMMd().format(DateTime.now()),style: subHeaderStyle,),
                    Text('Today',style: headingStyle,)
                  ],
                ),
                MyButton(label: '+ Add Task',onTap: onTap,)
              ],
            )
          ],
        ),
      ),
    );
  }

  void onTap(){

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
}
