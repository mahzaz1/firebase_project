import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/Firebase%20Services/provider.dart';
import '../Firebase/Firebase_Post.dart';
import 'package:firebase_project/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../Widgets/Button.dart';
import 'firestore_post.dart';

class AddFirestorePost extends StatefulWidget {
  const AddFirestorePost({Key? key}) : super(key: key);

  @override
  State<AddFirestorePost> createState() => _AddFirestorePostState();
}

class _AddFirestorePostState extends State<AddFirestorePost> {

  TextEditingController postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firestore Post'),
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
                    title: 'Add',
                    loading: provider.loading,
                    onTap: () {

                      provider.setLoading(true);
                      String id = DateTime.now().millisecondsSinceEpoch.toString();

                      fireStore.doc(id).set({
                        'Title':postController.text.toString(),
                        'id':id
                      }).then((value){

                        postController.clear();
                        provider.setLoading(false);
                        Utils().toastMessege('Post added', Colors.green);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FirestorePost()));



                      }).onError((error, stackTrace){
                        Utils().toastMessege(error.toString(), Colors.red);
                        provider.setLoading(false);

                      });


                    },);
                })

          ],
        ),
      ),
    );
  }
}
