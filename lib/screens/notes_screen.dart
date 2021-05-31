

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'add_staff.dart';
import 'package:image_picker/image_picker.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class Suborder {
  const Suborder(this.id, this.name);

  final String name;
  final int id;
}

class _MenuPageState extends State<MenuPage> {


  File _pickedImage;

  SharedPreferences sharedPreferences;



  Widget _buildImage() {
    if (_imageFile != null) {

      return Image.file(_imageFile,width: 100,height: 100);
    } else {
      return Text('Take an image to start', style: TextStyle(fontSize: 18.0));
    }
  }

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            )
    );

    if(imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if(file != null) {
        setState(() => _pickedImage = file);
      }
    }
  }

  DayOfWeek today;
  Suborder sub;

  File _imageFile;



  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        _imageFile = imageFile ;
      });
    } catch (e) {
      print(e);
    }
  }


  List<DayOfWeek> theWeek = <DayOfWeek>[
  const DayOfWeek(1, "Main course"),
  const DayOfWeek(2, "Desserts"),
  const DayOfWeek(2, "Starter"),
  const DayOfWeek(2, "test"),
  const DayOfWeek(2, "test2 cat"),
  const DayOfWeek(2, "Parantha"),
  const DayOfWeek(2, "Smoking")];


  List<DayOfWeek> theorder = <DayOfWeek>[
    const DayOfWeek(1, "Paneer"),
    const DayOfWeek(2, "Daal"),
    const DayOfWeek(2, "Bread"),
    const DayOfWeek(2, "yuy"),
    const DayOfWeek(2, "Test234"),
    const DayOfWeek(2, "chicken"),
    const DayOfWeek(2, "dal"),
    const DayOfWeek(2, "NA")

  ];

  List<DayOfWeek> foodtype = <DayOfWeek>[
    const DayOfWeek(1, "Veg"),
    const DayOfWeek(2, "Non Veg"),


  ];


  List<DayOfWeek> menutype = <DayOfWeek>[
    const DayOfWeek(1, "fixed"),
    const DayOfWeek(2, "half price"),


  ];


  List<DayOfWeek> gsttype = <DayOfWeek>[
    const DayOfWeek(1, "GST0"),
    const DayOfWeek(2, "GST05"),
    const DayOfWeek(2, "GST18"),
    const DayOfWeek(2, "VAT")


  ];

  Widget _buildButtons() {
    return ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(
                key: Key('retake'),
                text: 'Photos',
                onPressed: () => captureImage(ImageSource.gallery),
              ),
              _buildActionButton(
                key: Key('upload'),
                text: 'Camera',
                onPressed: () => captureImage(ImageSource.camera),
              ),
            ]));
  }




  Widget _buildActionButton({Key key, String text, Function onPressed}) {
    return Expanded(
      child: FlatButton(
          key: key,
          child: Text(text, style: TextStyle(fontSize: 20.0)),
          shape: RoundedRectangleBorder(),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: onPressed),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('ADD MENU'),
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

                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Food Name',
                              hintText: 'Food Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(

                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Food Detail',
                              hintText: 'Food Detail',
                            ),
                          ),
                        ),


                        Text("Maincourse", textAlign: TextAlign.center,
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

                        Text("Paneer", textAlign: TextAlign.center,
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
                          items: theorder.map((item) {
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

                        Text("Food Type", textAlign: TextAlign.center,
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
                          items: menutype.map((item) {
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

                        Text("Menu Price", textAlign: TextAlign.center,
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
                          items: menutype.map((item) {
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

                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Price',
                              hintText: 'Price',
                            ),
                          ),
                        ),

                        Text("GST0", textAlign: TextAlign.center,
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
                          items: gsttype.map((item) {
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

                        _pickedImage == null ?
                        Text("") :
                        Image(image: FileImage(_pickedImage),width: 100,height: 100,),

                       //Expanded(child:  _buildImage()),
                        // _buildButtons(),
              // Image.file(_imageFile,width: 100,height: 100);

                        RaisedButton(
                          elevation: 15.0,

                          padding: EdgeInsets.all(25.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.red,
                          onPressed: _pickImage,
                          child: Text(
                            'GALLERY/CAMERA',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Itim-Regular',
                            ),
                          ),
                        ),

                      ],

                    )
                )
            )
        )


    );
  }
}

