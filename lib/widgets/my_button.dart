
import 'package:flutter/cupertino.dart';

import '../misc/app_colors.dart';

class MyButton extends StatelessWidget {
  String label;
  final Function onTap;
  MyButton({Key? key,required this.label,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.bluishColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child:  Center(child: Text(label,style: const TextStyle(color: AppColors.whiteColor),)),
      ),
    );
  }
}
