import 'package:flutter/material.dart';
import './sideBar.dart';
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(19, 22, 40, 1),
          title: Text("Smart Dine"),
        ),
        body: Container(
          child: Text(
            'Calendar Page',
            style: TextStyle(
              color: Color.fromRGBO(19, 22, 40, 1),
              fontFamily: 'Courgette',
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
        ),
        drawer: SideBar()
    );
  }
}

