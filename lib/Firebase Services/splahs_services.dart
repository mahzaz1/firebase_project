import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/Auth/Login.dart';
import 'package:flutter/material.dart';
import '../UI/Home.dart';
class SplashServices{

  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    Timer(Duration(seconds: 3), () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              user == null? LoginScreen(): Home()));

        });

  }

  double height=10;
  double width=10;
  double turns = 0.0;

  void animate(){
    Timer(Duration(milliseconds: 5), () {
      height = 300;
      width = 300;
      turns = 1.0;
    });
  }

}