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
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Timer _timer;
int _start = 10;

void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {},
  );
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _loading = false;
  bool resendBool = false;
  bool resendButtonBool = false;
  bool _phoneNumber = true;
  String _buttonString = 'LOGIN';
  Map<String, dynamic> deviceData;
  SharedPreferences sharedPreferences;
  String deviceId = '';
  final TextEditingController _pinPutController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  //60 second duration of timer
  CountDownController _controller = CountDownController();
  int _duration = 60;

  _onChanged(String name,String mobile_no,String user_type) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("mobile_no", mobile_no);
      sharedPreferences.setString("name", name);
      sharedPreferences.setString("user_type", user_type);
      sharedPreferences.commit();
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  final FocusNode _pinPutFocusNode = FocusNode();

//ui for pinput
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent),
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white);
  }

  void _resend() async {
    //get device id for android device

    String decodedResponse = '';
    String name;
    //API call here for verifying otp
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/Supervisor/Api/resend_otp_data');
//map of string and object type used in http post
    var map = new Map<String, dynamic>();
    //get mobile number from phone textfield
    map['mobile_no'] = _phoneController.text;
    map['device_id'] = deviceId;
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
      //String messageResponse = mapOtpResponse['data']['message'];
      //String mobile_no =  mapOtpResponse['data']['mobile_no'];
      //String user_type  =  mapOtpResponse['data']['user_type'];
      //String name  =  mapOtpResponse['data']['name'];

      //_onChanged(name, mobile_no, user_type);

      setState(() {
        resendBool=true;
        resendButtonBool=false;
      });
      //if messageResponse is invalid otp display the message of invalid otp
      //else proceed to homescreen

    } catch (e) {
      //Write exception statement here

    }
  }

  //fetch deviceid, mobileno, text from pinput, json parsing and move to another screen
  // if message is success else show error message
  void _otpenter(String otp) async {
    //get device id for android device

    String decodedResponse = '';
    String name;
    //API call here for verifying otp
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/Supervisor/Api/verification_otp_data');
//map of string and object type used in http post
    var map = new Map<String, dynamic>();
    //get mobile number from phone textfield
    map['mobile_no'] = _phoneController.text;
    map['device_id'] = deviceId;
    map['otp'] = otp; //otp here
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
      print('checking'+mapOtpResponse.toString());
      print('hii');
      String req = mapOtpResponse['data']['message'];

      print('check'+req);
      String messageResponse = mapOtpResponse['data']['message'];

      //if messageResponse is invalid otp display the message of invalid otp
      //else proceed to homescreen
      if (messageResponse == 'Invalid Otp') {
        Fluttertoast.showToast(
            msg: messageResponse,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _navigateToNextScreen(context);
      }
    } catch (e) {
      //Write exception statement here

    }
  }
  void resendPress () async
  {

  }

  // called when login button is pressed mobileno fetched from their text field
  void _loginPress(buttonPressed) async {
    if (!(buttonPressed == 'ENTER OTP')) {
      if (!(_phoneController.text == '')) {
        String decodedResponse = '';
        //API call here
        var urlSent = Uri.encodeFull(
            'http://35.154.190.204/Restaurant/index.php/Supervisor/Api/login');

        var map = new Map<String, dynamic>();
        map['mobile_no'] = _phoneController.text;
        map['notification_id'] = '234'; //notification here
        map['device_id'] = deviceId; //device id here
        print('test'+deviceId);
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

          Map<String, dynamic> map1 =
              jsonDecode(decodedResponse); // import 'dart:convert';
       print('demo'+decodedResponse);
          String name = map1['data']['message'];
          Fluttertoast.showToast(
              msg: name,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } catch (e) {
          //Write exception statement here

        }
      }
    }
    setState(() {
      // login button pressed
      if (buttonPressed == 'LOGIN') {

        // if phone number is not blank
        if (!(_phoneController.text == '')) {
          resendBool = true;
          //change login text of button to enter otp
          //phone number boolean is set to false show otp screen
          _phoneNumber = false;
          _buttonString = 'ENTER OTP';
        } else {
          //else show message of enter mobile number
          Fluttertoast.showToast(
              msg: 'Enter mobile number',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else if (buttonPressed == 'ENTER OTP') {
        //call otp verify rest api
        _otpenter(_pinPutController.text);
      }
    });
  }

  //Navigator function to navigate to home page
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  // called when screen is initialized
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

    if (!mounted) return;
  }

//map of string and object for android device
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

  //function for calling textfield for entering mobile number
  Widget _buildMobilenoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _phoneController,
            maxLengthEnforced: true,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Itim-Regular', fontSize: 20),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone_android_outlined,
                color: Colors.white,
              ),
              hintText: 'Enter your Phone Number',
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

//widget of countdown timer
  Widget _countdown() {
    return Column(
      children: [
        Text('Resend Otp In', style: TextStyle(color: Colors.white)),
        CircularCountDownTimer(
          // Countdown duration in Seconds.
          duration: _duration,

          // Countdown initial elapsed Duration in Seconds.
          initialDuration: 0,

          // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
          controller: _controller,

          // Width of the Countdown Widget.
          width: MediaQuery.of(context).size.width / 10,

          // Height of the Countdown Widget.
          height: MediaQuery.of(context).size.height / 10,

          // Ring Color for Countdown Widget.
          ringColor: Colors.grey[300],

          // Ring Gradient for Countdown Widget.
          ringGradient: null,

          // Filling Color for Countdown Widget.
          fillColor: Colors.purpleAccent[100],

          // Filling Gradient for Countdown Widget.
          fillGradient: null,

          // Background Color for Countdown Widget.
          backgroundColor: Colors.purple[500],

          // Background Gradient for Countdown Widget.
          backgroundGradient: null,

          // Border Thickness of the Countdown Ring.
          strokeWidth: 10.0,

          // Begin and end contours with a flat edge and no extension.
          strokeCap: StrokeCap.round,

          // Text Style for Countdown Text.
          textStyle: TextStyle(
              fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold),

          // Format for the Countdown Text.
          textFormat: CountdownTextFormat.S,

          // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
          isReverse: true,

          // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
          isReverseAnimation: true,

          // Handles visibility of the Countdown Text.
          isTimerTextShown: true,

          // Handles the timer start.
          autoStart: true,

          // This Callback will execute when the Countdown Starts.
          onStart: () {
            // Here, do whatever you want
            print('Countdown Started');
          },

          // This Callback will execute when the Countdown Ends.
          onComplete: () {
            setState(() {
              resendBool = false;
              resendButtonBool = true;
            });
            // Here, do whatever you want
            print('Countdown Ended');
          },
        )
      ],
    );
  }

//otp user interface
  Widget _buildOTP() {
    return Container(
      //color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: PinPut(
        fieldsCount: 4,
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        submittedFieldDecoration: _pinPutDecoration.copyWith(
          borderRadius: BorderRadius.circular(20.0),
        ),
        selectedFieldDecoration: _pinPutDecoration,
        followingFieldDecoration: _pinPutDecoration.copyWith(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Colors.deepPurpleAccent.withOpacity(.5),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn(textValue) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 15.0,
        onPressed: () => _loginPress(textValue),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.lightGreen,
        child: Text(
          textValue,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Itim-Regular',
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Color.fromRGBO(19, 22, 40, 1),
                ),
                Container(
                  height: double.infinity,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 120.0,
                        ),
                        child: _loading == false
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image(
                                      width: double.infinity,
                                      image: AssetImage(
                                        'assets/logos/55176.jpg',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    'Smart Dine',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Courgette',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  _phoneNumber == true
                                      ? _buildMobilenoTF()
                                      : _buildOTP(),
                                  _buildLoginBtn(_buttonString),
                                  resendBool == true
                                      ? _countdown()
                                      : SizedBox(
                                          height: 1.0,
                                        ),
                                  resendButtonBool == true
                                      ? RaisedButton(
                                    onPressed: () => _resend(),
                                          color: Colors.purple,
                                          child: Text('Resend Otp',style: TextStyle(color: Colors.white,fontSize: 15),),

                                        )
                                      : SizedBox(
                                          height: 1.0,
                                        ),
                                ],
                              )
                            : Container(
                                child: Image(
                                image: AssetImage('assets/logos/loading.gif'),
                              ))),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
