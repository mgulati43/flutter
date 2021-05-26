import 'package:flutter/material.dart';
import './sideBar.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class DayOfWeek {
  const DayOfWeek(this.id, this.name);

  final String name;
  final int id;
}

class _NotesPageState extends State<NotesPage> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  DayOfWeek today;

  List<DayOfWeek> theWeek = <DayOfWeek>[
    const DayOfWeek(1, "Male"),
    const DayOfWeek(2, "Female"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter TextField Example'),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
    child: new SingleChildScrollView(
    child: new ConstrainedBox(
    constraints: new BoxConstraints(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Your Name',
                      hintText: 'Enter Your Name',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact Number',
                      hintText: 'Contact Number',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email id',
                      hintText: 'Email id',
                    ),
                  ),
                ),
                SizedBox(
                    width: double.infinity, // <-- match_parent
                    child:  RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text(selectedDate.toString()),
                      onPressed: () => _selectDate(context),
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Aadhar Number',
                      hintText: 'Aadhar Number',
                    ),
                  ),
                ),

                Text("Gender",textAlign: TextAlign.center,style: TextStyle(
                    color: Colors.black, decoration: TextDecoration.none,fontSize: 22.0)),
                DropdownButton<DayOfWeek>(

                  value: today,
                  onChanged: (DayOfWeek val) {
                    setState(() {
                      today = val;
                    });
                  },
                  items: theWeek.map((item) {
                    return DropdownMenuItem<DayOfWeek>(
                      value: item,
                      child: Text(
                        item.name,
                          textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, decoration: TextDecoration.none,fontSize: 22.0),
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pan Number',
                      hintText: 'Pan Number',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Designation',
                      hintText: 'Designation',
                    ),
                  ),


                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Current Address',
                      hintText: 'Current Address',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Permanent Address',
                      hintText: 'Permanent Address',
                    ),
                  ),
                ),

              ],

            )))));
  }
}
