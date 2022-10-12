import 'package:flutter/material.dart';
class Button extends StatelessWidget {
   Button({Key? key,required this.title, required this.onTap,this.loading = false}) : super(key: key);

  String title;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: loading?CircularProgressIndicator(color: Colors.white,strokeWidth: 5,): Text(title,style: TextStyle(color: Colors.white),textScaleFactor: 1.2,)),
      ),
    );
  }
}
