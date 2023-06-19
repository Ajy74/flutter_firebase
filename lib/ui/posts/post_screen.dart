import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Auth/login_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Screen"),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(onPressed:() {
            final auth = FirebaseAuth.instance;
            auth.signOut().then((value) {
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
            });
          }, 
          icon: Icon(Icons.logout_outlined)),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(

      ),
    );
  }
}