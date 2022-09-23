import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/ui/theme.dart';
import 'package:notes_app/widgets/my_input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
   DateTime _selectedDate = DateTime.now();
   String startTime = "9:30 PM";
   String endTime = DateFormat("HH:mm a").format(DateTime.now());
   int selectedRemind = 5;
   List<int> list = [
     5,10,15,20
   ];
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
              MyInputField(text: 'Title', hint: 'Enter Title Here'),
              MyInputField(text: 'Note', hint: 'Enter Note Here'),
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
                  iconSize: 20,
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
                ),)
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
}
