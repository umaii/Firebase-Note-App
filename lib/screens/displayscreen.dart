import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  final docId;
  final title;

  const DisplayScreen(
      {Key key, this.docId, this.title,})
      : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  FirebaseUser user;
  Firestore firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();
  FocusNode titleFocus = FocusNode();
  bool edit = false;
  String documentID;

  /* void initState() {
    edit = widget.edit;
    super.initState();
  }
*/

  getUser() async {
    user = await _auth.currentUser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  updateNote() {
    firestore
        .collection("users")
        .document(user.uid)
        .collection("notes")
        .document(documentID)
        .updateData(
      {
        "title": "${_title.text}",
        "content": "${_content.text}",
      },
    );
    _title.clear();
    _content.clear();
    setState(() {
      edit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              _buildSaveEdit(),
            ],
          ),
        ],
      ),
      body: edit ? _buildEdit() : _buildNoteContent(),
    );
  }

  Widget _buildNoteContent() {
    return ListView(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Center(
          child: Text(
            widget.title["title"],
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text(
          widget.title["content"],
          style: TextStyle(fontSize: 16),
        ),
      ),
    ]);
  }

  Widget _buildEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _title,
              focusNode: titleFocus,
              decoration: InputDecoration.collapsed(
                hintText: widget.title["title"],
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(
              color: Theme.of(context).accentColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: TextField(
              controller: _content,
              decoration: InputDecoration.collapsed(
                hintText: widget.title["content"],
                hintStyle: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildSaveEdit() {
    if (edit) {
      return IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          updateNote();
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
         // edit = true;
         setState(() {
           documentID = widget.docId.documentID;
           _title.text =  widget.title["title"];
           _content.text = widget.title["content"];
           edit = true;
         });
        },
      );
    }
  }
}
