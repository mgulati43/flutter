import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './sideBar.dart';
import 'package:intl/intl.dart';
import 'package:device_info/device_info.dart';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

// shared pref admin id all details list of string
//conditional login of otp else error message user on same screen
//resend otp after 60 seconds
import 'package:http/http.dart' as http;
import 'package:login_app/utilities/constants.dart';


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
  String deviceId = '';

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      //used for android device id
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

//map of string and object for ios device
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      // used for ios device id
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // deviceinfo plugin coming from deviceinfo.dart package
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    //device
    Map<String, dynamic> _deviceData = <String, dynamic>{};
    //devicedata for android or ios device
    deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        //map of string and dynamic(it contains string int object) by calling readandroidbuilddata and passing androidinfo as parameter
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        deviceId = deviceData['androidId'];
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        deviceId = deviceData['identifierForVendor'];
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }













      }

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
    //get device id for android device

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
      //map of string and object type used for storing data coming from otp response
      Map<String, dynamic> mapOtpResponse = jsonDecode(decodedResponse);
      //fetch message Response status ie invalid otp or valid otp
      print('checking' + mapOtpResponse.toString());
      Map<String, dynamic> map1 =
      jsonDecode(decodedResponse); // import 'dart:convert';
      print('demo'+decodedResponse);
      String name = map1['data']['status'];
      if(name=="1")
        {
          Fluttertoast.showToast(
              msg: 'Registration Successful',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      else
        {
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: namecontroller,
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
                            controller: contactcontroller,
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
                            controller: emailcontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email id',
                              hintText: 'Email id',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: double.infinity, // <-- match_parent
                            child: RaisedButton(
                              textColor: Colors.white,
                                color: Colors.red,
                              child: Text(formattedDate),
                              onPressed: () => _selectDate(context),
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: adharcontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Aadhar Number',
                              hintText: 'Aadhar Number',
                            ),
                          ),
                        ),

                        Text("Gender", textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 22.0)),
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
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: pancontroller,
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
                            controller: designationcontroller,
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
                            controller: currentaddresscontroller,
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
                            controller: permanentaddresscontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Permanent Address',
                              hintText: 'Permanent Address',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: double.infinity, // <-- match_parent
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.red,
                              child: Text('SUBMIT'),
                              onPressed: () => _addStaff(),

                            )
                        ),
                      ],

                    )
                )
            )
        )
    );
  }

}

