import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/ui/theme.dart';

class MyInputField extends StatelessWidget {
  String text;
  String hint;
  TextEditingController? textEditingController;
  Widget? widget;
  MyInputField({Key? key,
    required this.text,
    required this.hint,
    this.textEditingController,
    this.widget
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,style: titleStyle),
          Container(
            margin : const EdgeInsets.only(top: 8.0),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    controller: textEditingController,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0.0
                        )
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: context.theme.backgroundColor,
                              width: 0.0
                          )
                      )
                    ),
                  ),
                ),
                widget == null ? Container() : Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
