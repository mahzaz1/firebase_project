import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void toastMessege (String messegse,Color color){
    Fluttertoast.showToast(
        msg: messegse,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white
    );
  }
}