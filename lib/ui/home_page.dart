
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/services/theme_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          ThemeService().switchTheme();
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
