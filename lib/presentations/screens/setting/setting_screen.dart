import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.teal,
            ),
            onPressed: () {
              Get.back();
            }),
        elevation: 0,
        title: Text(
          "Pengaturan",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text("Pengaturan"),
      ),
    );
  }
}
