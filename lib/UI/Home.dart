import 'package:firebase_project/UI/Firebase/Firebase_Post.dart';
import 'package:firebase_project/UI/Firestore/firestore_post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/Utils.dart';
import 'Auth/Login.dart';
import 'changePassword.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          }).onError((error, stackTrace) {
                            Utils()
                                .toastMessege(error.toString(), Colors.red);
                          });
                        },
                        child: Text('Logout'))),
                PopupMenuItem(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword()));
                        },
                        child: Text('Change Password'))),
              ]),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FirebasePost()));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1,color: Colors.black)
                  ),
                  child: Center(
                    child: Text('Start With Firebase',textScaleFactor: 1.2,),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FirestorePost()));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1,color: Colors.black)
                  ),
                  child: Center(
                    child: Text('Start With Firestore',textScaleFactor: 1.2,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
