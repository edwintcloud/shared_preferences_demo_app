//===================================================================
// File: main.dart
//
// Desc: Main entry point for application.
//
// Copyright © 2019 Edwin Cloud. All rights reserved.
//
// * Attribution to Tensor and his channel on YouTube at      *
// * https://www.youtube.com/channel/UCYqCZOwHbnPwyjawKfE21wg *
//===================================================================

//-------------------------------------------------------------------
// Imports
//-------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

//-------------------------------------------------------------------
// Main Entrypoint
//-------------------------------------------------------------------
void main() => runApp(MyApp());

//-------------------------------------------------------------------
// MyApp (Class) - StatelessWidget
//-------------------------------------------------------------------
class MyApp extends StatelessWidget {
  // build app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Shared Preferences Demo"),
        ),
        body: Home(),
      ),
    );
  }
}

//-------------------------------------------------------------------
// Home (Class) - StatefulWidget
//-------------------------------------------------------------------
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

//-------------------------------------------------------------------
// HomeState (Class) - State<Home>
//-------------------------------------------------------------------
class HomeState extends State<Home> {
  // class variables (State)
  Future<SharedPreferences> _sPrefs = SharedPreferences.getInstance();
  final TextEditingController controller = TextEditingController();
  List<String> listOne, listTwo;

  // initializer
  @override
  void initState() {
    super.initState();
    listOne = [];
    listTwo = [];
  }

  // build home state
  @override
  Widget build(BuildContext context) {
    getStrings();
    return Center(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(6.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Type in something...",
              ),
            ),
          ),
          RaisedButton(
            child: Text("Submit"),
            onPressed: () {
              addString();
            },
          ),
          RaisedButton(
            child: Text("Clear"),
            onPressed: () {
              clearItems();
            },
          ),
          Flex(
            direction: Axis.vertical,
            children: listTwo == null
                ? []
                : listTwo
                    .map((String s) => Dismissible(
                          key: Key(s),
                          onDismissed: (direction) {
                            updateStrings(s);
                          },
                          child: ListTile(
                            title: Text(s),
                          ),
                        ))
                    .toList(),
          )
        ],
      ),
    );
  }

  // add string to list and to shared preferences
  Future<Null> addString() async {
    final SharedPreferences prefs = await _sPrefs;
    listOne.add(controller.text);
    prefs.setStringList('list', listOne);
    setState(() {
      controller.text = "";
    });
  }

  // clear items from shared preferences
  Future<Null> clearItems() async {
    final SharedPreferences prefs = await _sPrefs;
    prefs.clear();
    setState(() {
      listOne = [];
      listTwo = [];
    });
  }

  // get items from shared preferences
  Future<Null> getStrings() async {
    final SharedPreferences prefs = await _sPrefs;
    listTwo = prefs.getStringList('list');
    setState(() {});
  }

  // update shared preferences by removing str from it
  Future<Null> updateStrings(String str) async {
    final SharedPreferences prefs = await _sPrefs;
    setState(() {
      listOne.remove(str);
    });
    prefs.setStringList('list', listOne);
  }
}
