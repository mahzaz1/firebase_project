import 'package:firebase_project/UI/Firestore/add_firestore_post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/Auth/Login.dart';
import 'package:firebase_project/utils/Utils.dart';
import '../changePassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestorePost extends StatefulWidget {
  const FirestorePost({Key? key}) : super(key: key);

  @override
  State<FirestorePost> createState() => _FirestorePostState();
}

class _FirestorePostState extends State<FirestorePost> {


  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();

  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  final fireStoreCollection = FirebaseFirestore.instance.collection('users');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Post'),
        centerTitle: true,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddFirestorePost()));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  hintText: 'Search', border: OutlineInputBorder()),
              onChanged: (String value) {
                setState(() {});
              },
            ),

            StreamBuilder<QuerySnapshot>(
              stream: fireStore,
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){

                if(snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                if(snapshot.hasError)
                  return Text('Error');

                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){

                          final title = snapshot.data!.docs[index]['Title'].toString();
                          final id = snapshot.data!.docs[index]['id'].toString();

                          if(searchController.text.isEmpty){
                            return Card(
                              child: ListTile(

                                title: Text(snapshot.data!.docs[index]['Title'].toString()),

                                  trailing: PopupMenuButton(
                                    icon: Icon(Icons.more_vert),
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        value:1,
                                        child: ListTile(
                                          title: Text('Edit'),
                                          trailing: Icon(Icons.edit),
                                          onTap: (){
                                            Navigator.pop(context);
                                            showMyDialog(title,id);
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          title: Text('Delete'),
                                          trailing: Icon(Icons.delete),
                                          onTap: (){
                                            fireStoreCollection.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                            Navigator.pop(context);
                                            Utils().toastMessege('Post Deleted', Colors.green);

                                          },
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            );
                          }else if(title.toLowerCase().contains(searchController.text.toLowerCase())){
                            return Card(
                              child: ListTile(
                                title: Text(snapshot.data!.docs[index]['Title'].toString()),
                              ),
                            );

                          }else{
                            return Container();
                          }


                        })
                );

                })


          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                    hintText: 'Edit'
                ),
              ),
            ),
            actions: [

              TextButton(onPressed: (){

                Navigator.pop(context);

              }, child: Text('Cancel')),

              TextButton(onPressed: (){

                Navigator.pop(context);
                fireStoreCollection.doc(id).update({
                  'Title': editController.text.toString()
                }).then((value) {
                  Utils().toastMessege('Post Updated', Colors.green);


                }).onError((error, stackTrace){
                  Utils().toastMessege(error.toString(), Colors.red);


                });

              }, child: Text('Update')),
            ],
          );
        });
  }
}
