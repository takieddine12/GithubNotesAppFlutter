
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:notes_app/services/notification_services.dart';
import 'package:notes_app/services/theme_service.dart';

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
      body: const Center(
        child: Text('Theme Data'),
      ),
    );
  }

  _appBar(){
    return AppBar(
      leading: GestureDetector(
        onTap: (){
          print('Tapped');

          // Switch App Theme
          ThemeService().switchTheme();
          // Display Notification To User
          notificationHelper.displayNotification(
              title: 'Simple Notification',
              body: Get.isDarkMode ? 'Activated Dark Mode' : 'Activated Light Mode');

          // Schedule Notification For Certain interval To Show
        },
        child: const Icon(Icons.nightlight_round,size: 20,),
      ),
      actions:  [
        Container(
            padding: const EdgeInsets.only(right: 10),
            child: const Icon(Icons.person,size: 20,)),
      ],
    );
  }


}
