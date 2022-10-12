import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_project/UI/Auth/Login.dart';
import 'package:firebase_project/Widgets/TextForm.dart';
import 'package:firebase_project/utils/Utils.dart';
import 'package:flutter/material.dart';

import '../changePassword.dart';
import 'Firebase_AddPost.dart';

class FirebasePost extends StatefulWidget {
  FirebasePost({Key? key}) : super(key: key);

  @override
  State<FirebasePost> createState() => _FirebasePostState();
}

class _FirebasePostState extends State<FirebasePost> {

  final databaseRef = FirebaseDatabase.instance.ref('Test');
  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Post'),
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
              context, MaterialPageRoute(builder: (context) => AddFirebasePost()));
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
            Expanded(
              child: FirebaseAnimatedList(
                query: databaseRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('Title').value.toString();
                  final id = snapshot.child('id').value.toString();
                  if (searchController.text.isEmpty) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.child('Title').value.toString()),
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
                                  databaseRef.child(snapshot.child('id').value.toString()).remove();
                                  Navigator.pop(context);
                                  Utils().toastMessege('Post Deleted', Colors.green);

                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  else if (title.toLowerCase().contains(searchController.text.toLowerCase())) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.child('Title').value.toString()),
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
                                  databaseRef.child(snapshot.child('id').value.toString()).remove();
                                  Navigator.pop(context);
                                  Utils().toastMessege('Post Deleted', Colors.green);

                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),

            // Expanded(
            //     child: StreamBuilder(
            //   stream: databaseRef.onValue,
            //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            //     if (!snapshot.hasData) {
            //       return CircularProgressIndicator();
            //     } else {
            //
            //       Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
            //       List<dynamic> list = [];
            //       list.clear();
            //       list = map.values.toList();
            //
            //       return ListView.builder(
            //         itemCount: snapshot.data!.snapshot.children.length,
            //           itemBuilder: (context, index) {
            //
            //         return Card(
            //           child: ListTile(
            //             title: Text(list[index]['Title']),
            //           ),
            //         );
            //       });
            //     }
            //   },
            // ))
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
              }, child: Text('Cancel')
              ),

              TextButton(onPressed: (){
                Navigator.pop(context);
                databaseRef.child(id).update({
                  'Title':editController.text.toString()
                }).then((value){
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
