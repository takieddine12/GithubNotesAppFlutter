import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/task_controller.dart';
import 'package:notes_app/misc/app_colors.dart';
import 'package:notes_app/models/task_model.dart';
import 'package:notes_app/ui/theme.dart';
import 'package:notes_app/widgets/my_input_field.dart';

import '../widgets/my_button.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
   final TaskController _taskController = Get.put(TaskController());
   final TextEditingController _titleController = TextEditingController();
   final TextEditingController _noteController = TextEditingController();
   DateTime _selectedDate = DateTime.now();
   String startTime = "9:30 PM";
   String endTime = DateFormat("HH:mm a").format(DateTime.now());
   int selectedRemind = 5;
   List<int> list = [
     5,10,15,20
   ];

   String selectedRepeat  = 'None';
   List<String> repeatList  = [
   'None','Daily',"Weekly",'Monthly'
   ];

   int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Task',style: headingStyle,),
              MyInputField(text: 'Title', hint: 'Enter Title Here',textEditingController: _titleController,),
              MyInputField(text: 'Note', hint: 'Enter Note Here',textEditingController: _noteController,),
              MyInputField(text: 'Date', hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(onPressed: (){
                _getDateFromUser();
              },icon: const Icon(Icons.calendar_month_sharp),),),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(text: 'Start Time', hint: startTime,
                      widget: IconButton(onPressed: (){
                        _getTimeFromUser(true);
                      },icon: const Icon(Icons.access_time),),),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: MyInputField(text: 'End Time', hint: endTime,
                      widget: IconButton(onPressed: (){
                        _getTimeFromUser(false);
                      },icon: const Icon(Icons.access_time),),),
                  ),
                ],
              ),
              MyInputField(text: 'Remind', hint: '$selectedRemind minutes early',
                widget: DropdownButton(
                  icon: const Icon(Icons.arrow_drop_down_outlined,color: Colors.grey,),
                  iconSize: 30,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? value) {
                    setState(() {
                      selectedRemind = int.parse(value!);
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString())
                    );
                  }).toList(),
                ),),
              MyInputField(text: 'Repeat', hint: selectedRepeat, widget: DropdownButton(
                icon: const Icon(Icons.arrow_drop_down_outlined,color: Colors.grey,),
                iconSize: 30,
                underline: Container(height: 0,),
                style: subTitleStyle,
                onChanged: (String? value){
                  setState(() {
                    selectedRepeat = value!;
                  });
                },
                items: repeatList.map<DropdownMenuItem<String>>((String value){
                   return DropdownMenuItem(
                     value: value,
                     child: Text(value),
                   );
                }).toList(),
              ),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('Color',style: titleStyle,),
                         Padding(
                           padding: const EdgeInsets.only(top: 10),
                           child: Wrap(
                            children: List<Widget>.generate(3, (index){
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedColor = index;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: index == 0 ? AppColors.primaryColor : index == 1 ? AppColors.pinkColor : AppColors.yellowColor ,
                                    child: selectedColor == index ? const Icon(Icons.done,color: Colors.white,size: 14,) : Container(),
                                  ),
                                ),
                              );
                            }),
                        ),
                         )
                      ],
                    ),
                    GestureDetector(
                        onTap: (){
                          _validateForm();
                        },
                        child: MyButton(label: 'Create Task'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child:  Icon(
          Icons.arrow_back_ios_new,
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
  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2030));

    if(_pickerDate != null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }
  _getTimeFromUser(bool isStartTime) async {
     var pickedTime =  await _showTimePicker();
     String _formattedTime = pickedTime.format(context);
     if(pickedTime == null){
         print("Cannot get time");
     } else if (isStartTime == true){
        setState(() {
          startTime = _formattedTime;
        });
     } else if (isStartTime == false){
       setState(() {
         endTime = _formattedTime;
       });
     }
  }
  _showTimePicker() {
    return  showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime:  TimeOfDay(
            hour: int.parse(startTime.split(':')[0]),
            minute: int.parse(endTime.split(':')[1].split(' ')[0])));
  }
  _validateForm(){
    if(_titleController.text.isNotEmpty &&  _noteController.text.isNotEmpty){
      _addDataToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar(
          'Required',
          'All Fields are required !',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: AppColors.pinkColor,
          icon: const Icon(Icons.warning,color: Colors.red,));
    }
  }
   _addDataToDB() async {
     int result = await _taskController.insertTask(TaskModel(
       title: _titleController.text,
       note: _noteController.text,
       isCompleted: 0,
       date:  DateFormat.yMd().format(_selectedDate),
       startTime: startTime,
       endTime: endTime,
       color: selectedColor,
       remind: selectedRemind,
       repeat: selectedRepeat
     ));
     print("result is $result");
   }
}
