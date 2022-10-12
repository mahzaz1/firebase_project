import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/Firebase%20Services/provider.dart';
import 'package:firebase_project/Widgets/TextForm.dart';
import 'package:firebase_project/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/Button.dart';
import '../Firebase/Firebase_Post.dart';


class VerifyPhone extends StatelessWidget {
   VerifyPhone({Key? key, required this.verfivationId}) : super(key: key);

  final String verfivationId;
  TextEditingController phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Phone Number'),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextForm(
                  labelText: 'OTP',
                  hintText: '6 Digit Code',
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  validator: (value){},
                  icon: Icon(Icons.phone)),
              SizedBox(height: 30,),
              Consumer<AuthProvider>(builder: (context,provider,child){
                return Button(
                  loading: provider.loading,
                  title: 'Verify',
                  onTap: () async{
                    provider.setLoading(true);
                    final credential = PhoneAuthProvider.credential(
                        verificationId: verfivationId,
                        smsCode: phoneController.text.toString());

                    try{
                      await auth.signInWithCredential(credential);

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>FirebasePost()));
                      provider.setLoading(false);

                    }catch(e){
                      provider.setLoading(false);

                      Utils().toastMessege(e.toString(), Colors.red);
                    }
                  },);
              })


            ],
          ),
        ),
      ),
    );
  }
}