import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/Firebase%20Services/provider.dart';
import '../Firebase/Firebase_Post.dart';

import 'package:firebase_project/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/Button.dart';

class AddFirebasePost extends StatefulWidget {
  AddFirebasePost({Key? key}) : super(key: key);

  @override
  State<AddFirebasePost> createState() => _AddFirebasePostState();
}

class _AddFirebasePostState extends State<AddFirebasePost> {
  TextEditingController postController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref('Test');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firebase Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(

          children: [
            SizedBox(height: 50,),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                  hintText: 'Whats in your mind',
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple))
              ),),
            SizedBox(height: 40,),
            Consumer<AuthProvider>(
                builder: (context,provider,child){
                  return Button(
                    loading: provider.loading,
                    title: 'Add',
                    onTap: () {

                      provider.setLoading(true);

                      String id = DateTime.now().millisecondsSinceEpoch.toString();

                      databaseRef.child(id).set({
                        'id':id,
                        'Title': postController.text.toString()
                      }).then((value){

                        provider.setLoading(false);
                        Utils().toastMessege('Post Added', Colors.green);
                        postController.clear();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FirebasePost()));

                      }).onError((error, stackTrace){

                        provider.setLoading(false);
                        Utils().toastMessege(error.toString(), Colors.red);

                      });
                    },);
                })

          ],
        ),
      ),
    );
  }
}
