import 'package:flutter/material.dart';
import './sideBar.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(19, 22, 40, 1),
          title: Text("Smart Dine"),
        ),
        body: Container(
          child: Text(
            'Settings Page',
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
