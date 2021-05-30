import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import './sideBar.dart';

import 'add_staff.dart';
import 'notes_screen.dart';

class HomePage extends StatefulWidget {
  /*final int mobileNumber;
  final String userType;
  final String customerName;

  HomePage(this.mobileNumber, this.userType, this.customerName);*/

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  List<MenuJsonParser> foodItems = [];
  List<StaffJsonParser> staffList = [];
  //double listHeight = MediaQuery.of(context).size.height * .7;

  @override
  void initState() {
    super.initState();
    _loading = true;

    callListApi();
    callListApiStaff();
  }

  void addMenuScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MenuPage()));
  }

  void addStaff() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NotesPage()));
  }

  void callListApi() async {
    var response;
    String decodedResponse = '';
    //API call here
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/Supervisor/Api/menu_list_data');
    var map = new Map<String, dynamic>();
    map['admin_id'] = 'ADMIN_00001';
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;
      //print(jsonObjects);
      //jsonObjects.map((jsonObject) => print(jsonObject)).toList();
      setState(() {
        foodItems = jsonObjects
            .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
            .toList();
        _loading = false;
      });
    } catch (e) {
      //Write exception statement here

    }
  }

  void callListApiStaff() async {
    var response;
    String decodedResponse = '';
    //API call here
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/Supervisor/Api/get_staff_data');
    var map = new Map<String, dynamic>();
    map['admin_id'] = 'ADMIN_00001';
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;
      //print(jsonObjects);
      //jsonObjects.map((jsonObject) => print(jsonObject)).toList();
      setState(() {
        staffList = jsonObjects
            .map((jsonObject) => StaffJsonParser.fromJson(jsonObject))
            .toList();
      });
    } catch (e) {
      //Write exception statement here

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          drawer: SideBar(),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(19, 22, 40, 1),
            title: Text("SMART DINE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold)),
            elevation: 0,
          ),
          body: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Container(
                    color: Color.fromRGBO(19, 22, 40, 1),
                    child: Column(children: [
                      Container(
                          width: double.infinity,
                          height: 40,
                          margin: EdgeInsets.only(bottom: 10),
                          //color: Color.fromRGBO(19, 22, 40, 1),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.redAccent,
                                Colors.orangeAccent
                              ]),
                              borderRadius: BorderRadius.circular(150),
                              color: Colors.redAccent),
                          child: TextButton(
                              onPressed: () => addMenuScreen(),
                              child: Text(
                                'ADD MENU DETAIL',
                                style: TextStyle(color: Colors.white),
                              ))),
                      Container(
                          width: double.infinity,
                          height: 40,
                          margin: EdgeInsets.only(bottom: 10),
                          //color: Color.fromRGBO(19, 22, 40, 1),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.redAccent,
                                Colors.orangeAccent
                              ]),
                              borderRadius: BorderRadius.circular(150),
                              color: Colors.redAccent),
                          child: TextButton(
                              onPressed: () => addStaff(),
                              child: Text(
                                'ADD RESTAURANT STAFF',
                                style: TextStyle(color: Colors.white),
                              )))
                    ])),
                DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: TabBar(
                              unselectedLabelColor: Colors.white,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.redAccent,
                                    Colors.orangeAccent[700]
                                  ]),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.redAccent),
                              tabs: [
                                Tab(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("MENU DETAILS"),
                                  ),
                                ),
                                Tab(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("STAFF DETAILS"),
                                  ),
                                ),
                              ]),
                          color: Color.fromRGBO(19, 22, 40, 1),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height *
                                .65, //height of TabBarView
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                            child: TabBarView(children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: _loading == false
                                      ? ListView.builder(
                                          itemCount: foodItems.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                elevation: 10,
                                                //color: Colors.grey[300],
                                                child: ListTile(
                                                    title: Text(foodItems[index]
                                                        .menu_name),
                                                    subtitle: Text('Rs. ' +
                                                        foodItems[index]
                                                            .menu_fix_price),
                                                    leading: Image.memory(
                                                        foodItems[index]
                                                            .menu_image)));
                                          })
                                      : Container(
                                          child: Image(
                                          image: AssetImage(
                                              'assets/logos/loading.gif'),
                                        ))),
                              Container(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: _loading == false
                                      ? ListView.builder(
                                          itemCount: staffList.length,
                                          itemBuilder: (context, index) {
                                            return Card(
<<<<<<< Updated upstream
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: staffList[index].gender == 'Male'
                                                      ? AssetImage('assets/logos/UserIcon.jpg')
                                                      : AssetImage('assets/logos/images.png'),
                                                ),
                                                title: Text(
                                                  staffList[index].name + ' (' + staffList[index].desingination + ')',
                                                  style: TextStyle(
                                                    color: Colors.green[900],
=======

                                              child: ListTile(

                                                title: Text(
                                                  'Name ' +
                                                      staffList[index].name +
                                                      '\n',textAlign: TextAlign.center,
                                                  style:

                                                  TextStyle(
                                                    color: Colors.black,
>>>>>>> Stashed changes
                                                    letterSpacing: 1.5,
                                                    fontSize: 20.0,

                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(margin: EdgeInsets.only(bottom: 2, top: 10),
                                                    child: RichText(
                                                      
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                            child: Icon(Icons.phone_android_rounded, size: 20,color: Colors.red,),
                                                          ),
                                                          TextSpan(

                                                            text: staffList[index].mobile_no,
                                                            style:  TextStyle(
                                                              color: Colors.black,
                                                              letterSpacing: 1.5,
                                                              fontSize: 15.0,
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                    ),)
                                                    ,
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                            child: Icon(Icons.email_rounded, size: 20,color: Colors.blue,),
                                                          ),
                                                          TextSpan(
                                                            text: staffList[index].email,
                                                            style:  TextStyle(
                                                              color: Colors.black,
                                                              letterSpacing: 1.5,
                                                              fontSize: 15.0,
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ),
                                            );
                                          })
                                      : Container(
                                          child: Image(
                                          image: AssetImage(
                                              'assets/logos/loading.gif'),
                                        ))),
                            ]))
                      ],
                    )),
              ])),
        ));
  }
}

class StaffJsonParser {
  String admin_id;
  String name;
  String mobile_no;
  String email;
  String date_of_birth;
  String aadhar_no;
  String pan_number;
  String desingination;
  String gender;
  String permanent_address;
  String current_address;
  String user_type;
  String message;
  String status;

  StaffJsonParser(
      this.admin_id,
      this.name,
      this.mobile_no,
      this.email,
      this.date_of_birth,
      this.aadhar_no,
      this.pan_number,
      this.desingination,
      this.gender,
      this.permanent_address,
      this.current_address,
      this.user_type,
      this.message,
      this.status);

  factory StaffJsonParser.fromJson(dynamic json) {
    return StaffJsonParser(
        json['admin_id'] as String,
        json['name'] as String,
        json['mobile_no'] as String,
        json['email'] as String,
        json['date_of_birth'] as String,
        json['aadhar_no'] as String,
        json['pan_number'] as String,
        json['desingination'] as String,
        json['gender'] as String,
        json['permanent_address'] as String,
        json['current_address'] as String,
        json['user_type'] as String,
        json['message'] as String,
        json['status'] as String);
  }
}

class MenuJsonParser {
  String menu_id;
  String admin_id;
  String menu_category_id;
  String menu_food_type;
  String menu_name;
  String rating;
  String cat_id;
  String sub_cat_id;
  Uint8List menu_image;
  String menu_detail;
  String menu_full_price;
  String menu_half_price;
  String menu_fix_price;
  String sub_cat_name;
  String cat_name;
  String nutrient_counts;
  String gst;
  String menu_half_price_gst;
  String menu_full_price_gst;
  String menu_fix_price_gst;
  String message;
  String status;

  MenuJsonParser(
      this.menu_id,
      this.admin_id,
      this.menu_category_id,
      this.menu_food_type,
      this.menu_name,
      this.rating,
      this.cat_id,
      this.sub_cat_id,
      this.menu_image,
      this.menu_detail,
      this.menu_full_price,
      this.menu_half_price,
      this.menu_fix_price,
      this.sub_cat_name,
      this.cat_name,
      this.nutrient_counts,
      this.gst,
      this.menu_half_price_gst,
      this.menu_full_price_gst,
      this.menu_fix_price_gst,
      this.message,
      this.status);

  factory MenuJsonParser.fromJson(dynamic json) {
    return MenuJsonParser(
        json['menu_id'] as String,
        json['admin_id'] as String,
        json['menu_category_id'] as String,
        json['menu_food_type'] as String,
        json['menu_name'] as String,
        json['rating'] as String,
        json['cat_id'] as String,
        json['sub_cat_id'] as String,
        base64.decode(json['menu_image']) as Uint8List,
        json['menu_detail'] as String,
        json['menu_full_price'] as String,
        json['menu_half_price'] as String,
        json['menu_fix_price'] as String,
        json['sub_cat_name'] as String,
        json['cat_name'] as String,
        json['nutrient_counts'] as String,
        json['gst'] as String,
        json['menu_half_price_gst'] as String,
        json['menu_full_price_gst'] as String,
        json['menu_fix_price_gst'] as String,
        json['message'] as String,
        json['status'] as String);
  }
}
