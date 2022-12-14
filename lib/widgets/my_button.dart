
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notes_app/ui/add_task_page.dart';

import '../misc/app_colors.dart';

class MyButton extends StatelessWidget {
  String label;
  MyButton({Key? key,required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 50,
      decoration: BoxDecoration(
          color: AppColors.bluishColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child:  Center(child: Text(label,style: const TextStyle(color: AppColors.whiteColor),)),
    );
  }
}
