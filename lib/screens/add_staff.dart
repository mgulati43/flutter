import 'package:flutter/material.dart';
import './sideBar.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(19, 22, 40, 1),
          title: Text("Smart Staff"),
        ),
        body: Container(

          child: TextField(

          ),

        ),
        drawer: SideBar()
    );
  }
}
