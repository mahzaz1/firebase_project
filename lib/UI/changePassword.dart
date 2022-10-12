import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utils/Utils.dart';
import 'package:flutter/material.dart';

import '../Widgets/TextForm.dart';
import 'Auth/Login.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();
  var newPassword = '';
  final newPasswordController = TextEditingController();

  void dispose(){
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  changePassword() async{
    if(_formKey.currentState!.validate()){
      await currentUser!.updatePassword(newPassword);
      Utils().toastMessege("Password Changed Successfully", Colors.green);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password'),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextForm(
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'New Password',
                    icon: Icon(Icons.remove_red_eye_rounded,color: Colors.white),
                    labelText: 'Password',
                    controller: newPasswordController,
                    validator: (value){

                      if(value == null || value.isEmpty ) {
                        return 'Please Enter password';
                      }
                      return null;

                    },
                  ),

                  SizedBox(height: 30,),

                  ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                            newPassword = newPasswordController.text;
                          changePassword();


                        }
                      },
                      child: Text('Change Password')),
                ],
              ),
            )),
      ),
    );
  }
}
