import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/Firebase%20Services/provider.dart';
import 'package:firebase_project/UI/Auth/Verify_Phone.dart';
import 'package:firebase_project/Widgets/Button.dart';
import 'package:firebase_project/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/TextForm.dart';

class Phone extends StatelessWidget {
  Phone({Key? key}) : super(key: key);

  TextEditingController phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignUp With Phone Number'),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextForm(
                    labelText: 'Phone',
                    hintText: 'Enter Your Phone Number',
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    validator: (value){
                      if (value!.contains(RegExp(r'[a-zA-Z]'))) {
                        return 'Enter Valid Number';
                      } else if(value!.isEmpty){
                        return 'This field is required';
                      }else {
                        return null;
                      }
                    },
                    icon: Icon(Icons.phone)),
                SizedBox(height: 80,),
                Consumer<AuthProvider>(
                    builder: (context,provider,child){
                      return Button(title: 'Verify',
                        loading: provider.loading,
                        onTap: () {
                        provider.setLoading(true);
                          auth.verifyPhoneNumber(
                              phoneNumber: phoneController.text,
                              verificationCompleted: (_){
                                provider.setLoading(false);
                              },
                              verificationFailed: (e){
                                Utils().toastMessege(e.toString(), Colors.red);
                                provider.setLoading(false);

                              },
                              codeSent: (String verificationId, int? Token){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPhone(verfivationId: verificationId,)));
                                provider.setLoading(false);

                              },
                              codeAutoRetrievalTimeout: (e){
                                Utils().toastMessege(e.toString(), Colors.red);
                                provider.setLoading(false);

                              }
                          );
                        },);

                    }),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
