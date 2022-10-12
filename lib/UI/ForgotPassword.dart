import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/Auth/Login.dart';
import 'package:flutter/material.dart';

import '../Widgets/Button.dart';
import '../Widgets/TextForm.dart';
import '../utils/Utils.dart';

class ForgetPassword extends StatelessWidget {
   ForgetPassword({Key? key}) : super(key: key);

   FirebaseAuth _auth = FirebaseAuth.instance;
   TextEditingController emailController = TextEditingController();

   Forget(){
     _auth.sendPasswordResetEmail(email: emailController.text).then((value){
       Utils().toastMessege('Email Send, Please Check', Colors.green);
     }).onError((error, stackTrace){
       Utils().toastMessege(error.toString(), Colors.red);
     });
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ForgetPassword'),centerTitle: true,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextForm(
                labelText: 'Email',
                hintText: 'Enter Your Email',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                icon: Icon(Icons.email),
                validator: (value) {
                  if (value! == null || value!.isEmpty) {
                    return 'Email is required';
                  } else if (!value.contains('@') ||
                      !value.contains('.')) {
                    return 'Enter valid email';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 30,),
              Button(title: 'Forget Password', onTap: () {
                Forget();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

              },)
            ],
          ),
        ),
      )
    );
  }
}


