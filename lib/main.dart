import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('flutter.native/helper');
  bool _switchValue = true;
  String ssid = 'Unknown';
  int strength = 0;

  @override
  void initState() {
    super.initState();
    _getWifiStatus();
    _getSSID();
    _getWifiStrength();
  }

  Future<void> _setWifiConnection() async {
      await platform.invokeMethod('setWifiConnection');
  }

  void _checkWifi(){
    _getWifiStatus();
    _getSSID();
    _getWifiStrength();
  }

  Future<void> _getWifiStatus() async {

      final bool result = await platform.invokeMethod('getWifiStatus');
      setState(() {
        _switchValue = result ;
      });

  }

  Future<void> _getSSID() async {
    final String result = await platform.invokeMethod('getSSID');
    setState(() {
      ssid = result ;
    });
  }

  Future<void> _getWifiStrength() async {
    final int result = await platform.invokeMethod('getStrengthOfSignal');
    setState(() {
      strength = result ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 200,
                child:  ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  child: Text('check'),
                  onPressed: _checkWifi,
                ),
              ),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("SSID: " + ssid, style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Strength of signal: \n" + strength.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("WIFI", style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child:  CupertinoSwitch(
                value: _switchValue,
                onChanged: (value) {
                  // _checkWifi();
                  _setWifiConnection();
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            ),
            // SizedBox(height: 12.0,),
            // Text('Value : $_switchValue', style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 20.0
            // ),),
           ],
        ),
      ),
    );
  }
}
