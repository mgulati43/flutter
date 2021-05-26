import 'package:flutter/material.dart';
import './sideBar.dart';
class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(19, 22, 40, 1),
          title: Text("Smart Dine"),
        ),
        body: Container(
          child: Text(
            'Orders Page',
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


