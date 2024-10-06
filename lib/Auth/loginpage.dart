import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mlp_administration/HomePage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool spinner = false;
  TextEditingController useridController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController administrationIdController = TextEditingController();
  login() {
    log("Login pressed!");
    setState(() {
      spinner = true;
    });
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: useridController.text.trim(),
        password: passController.text.trim());
    String? user = FirebaseAuth.instance.currentUser!.uid;
    log(user.toString());
    String smallString = user.substring(0, 5); //VH11CW5PKMMdnJkpNnd4tJck4lQ2
    if (smallString == administrationIdController.text.trim()) {
      setState(() {
      spinner = false;
    });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      setState(() {
      spinner = false;
    });
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          padding: EdgeInsets.all(20),
          content: Text('UNAUTHORIZE'),
          leading: Icon(Icons.info),
          backgroundColor: Colors.green,
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ModalProgressHUD(
            inAsyncCall: spinner,
            child: ListView(
              children: [
                Text("Enter the Data"),
                TextField(
                  controller: useridController,
                  decoration: InputDecoration(label: Text("Email ")),
                ),
                TextField(
                  controller: passController,
                  decoration: InputDecoration(label: Text("Password")),
                ),
                TextField(
                  controller: administrationIdController,
                  decoration: InputDecoration(label: Text("Adminstration ID")),
                ),
                CupertinoButton(
                    child: Text("Login"),
                    onPressed: () {
                      login();
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Homepage()));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
