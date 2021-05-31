import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

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
  Map<String, dynamic> deviceData;
  String formattedDate = 'Enter DOB ';
  String deviceId = 'Dkaflflkfakflaklfklfklkflkflkflkfflk';
  //this is global key
  final _formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController contactcontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController adharcontroller = new TextEditingController();
  TextEditingController pancontroller = new TextEditingController();
  TextEditingController designationcontroller = new TextEditingController();
  TextEditingController currentaddresscontroller = new TextEditingController();
  TextEditingController permanentaddresscontroller = new TextEditingController();
  DayOfWeek today;
  List<DayOfWeek> theWeek = <DayOfWeek>[
    const DayOfWeek(1, "Male"),
    const DayOfWeek(2, "Female"),
  ];

  void _addStaff() async {
    String decodedResponse = '';
    String name;
    //API call here for verifying otp
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/Supervisor/Api//staff_registration');
//map of string and object type used in http post
    var map = new Map<String, dynamic>();
    //get mobile number from phone textfield
    map['name'] = namecontroller.text;
    map['mobile_no'] = contactcontroller.text;
    map['email'] = emailcontroller.text;
    map['device_id'] = deviceId;
    map['notification_id'] = '1';
    map['date_of_birth'] = formattedDate;
    map['aadhar_no'] = adharcontroller.text;
    map['pan_number'] = pancontroller.text;
    map['desingination'] = designationcontroller.text;
    map['pan_number'] = pancontroller.text;
    map['gender'] = today.name;
    map['permanent_address'] = permanentaddresscontroller.text;
    map['current_address'] = currentaddresscontroller.text;
    map['user_type'] = designationcontroller.text;
    map['admin_id'] = 'ADMIN_00001';
    var url = Uri.parse(urlSent);
    var response;
    //http request by encoding request in utf8 format and decoding in utf8 format
    //content type application/x-www-form-urlencoded
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);
      //fetch message Response for registration of staff
      Map<String, dynamic> staffMap = jsonDecode(decodedResponse);
      String status = staffMap['data']['status'];
      if (status == "1") {
        Fluttertoast.showToast(
            msg: 'Registration Successful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        _navigateToNextScreen(context);
      } else {
        Fluttertoast.showToast(
            msg: 'Registration Failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      //Write exception statement here

    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate)
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee Details'),
          backgroundColor: Colors.black,
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: new SingleChildScrollView(
                child: new ConstrainedBox(
                    constraints: new BoxConstraints(),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //name textfield

                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                controller: namecontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Your Name',
                                  hintText: 'Enter Your Name',
                                ),
                              ),
                            ),
                            //contact number
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },

                                controller: contactcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Contact Number',
                                  hintText: 'Contact Number',
                                ),
                              ),
                            ),
                            //email id
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email id',
                                  hintText: 'Email id',
                                ),
                              ),
                            ),
                            //date of birth
                            SizedBox(
                                width: double.infinity, // <-- match_parent
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  child: Text(formattedDate),
                                  onPressed: () => _selectDate(context),
                                )),
                            //aadhar card textfield
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                controller: adharcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Aadhar Number',
                                  hintText: 'Aadhar Number',
                                ),
                              ),
                            ),
                            //gender text
                            Text("Gender",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontSize: 22.0)),
                            //gender dropdown
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
                                        color: Colors.black,
                                        decoration: TextDecoration.none,
                                        fontSize: 22.0),
                                  ),
                                );
                              }).toList(),
                            ),
                            //pan number textfield
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                controller: pancontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Pan Number',
                                  hintText: 'Pan Number',
                                ),
                              ),
                            ),
                            //designation textfield
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                controller: designationcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Designation',
                                  hintText: 'Designation',
                                ),
                              ),
                            ),
                            //current address
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                controller: currentaddresscontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Current Address',
                                  hintText: 'Current Address',
                                ),
                              ),
                            ),
                            //permanent address
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                controller: permanentaddresscontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Permanent Address',
                                  hintText: 'Permanent Address',
                                ),
                              ),
                            ),
                            // submit raised button
                            SizedBox(
                                width: double.infinity, // <-- match_parent
                                child: RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.red,
                                    child: Text('SUBMIT'),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _addStaff();
                                      }
                                    })),
                          ],
                        ))))));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }
}
