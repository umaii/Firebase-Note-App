import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_app/screens/displayscreen.dart';
import 'package:firebase_note_app/screens/note_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loginscreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseUser user;
  Firestore firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = true;

  getUser() async {
    user = await _auth.currentUser();
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  deleteNote(String id) {
    firestore
        .collection("users")
        .document(user.uid)
        .collection("notes")
        .document(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => _signOut(),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: loading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: StreamBuilder(
                        stream: firestore
                            .collection('users')
                            .document(user.uid)
                            .collection("notes")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot snap = snapshot?.data;
                            List<DocumentSnapshot> notes = snap?.documents;
                            if (notes.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No Notes',
                                      style: TextStyle(letterSpacing: 0.5),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Tap the purple Button to add a Note',
                                        style: TextStyle(letterSpacing: 0.1),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: notes?.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot doc = notes[index];
                                Map body = doc.data;

                                return Dismissible(
                                  key: ObjectKey("${notes[index]}"),
                                  background: stackBehindDismiss(),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (v) {
                                    deleteNote(doc.documentID);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => DisplayScreen(
                                              title: body,
                                              docId: doc,
                                            ),
                                          ),
                                        );
                                      },
                                      child: _buildNotes(
                                          context,
                                          "${body["title"]}",
                                          "${body["content"]}"),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Theme.of(context).accentColor,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  _signOut() async {
    await _auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
    );
  }
}

Widget _buildNotes(context, String title, String content) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 20, top: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              maxLines: 1,
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(right: 115),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
            maxLines: 3,
          ),
        ),
      ],
    ),
  );
}
