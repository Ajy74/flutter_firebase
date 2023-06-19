import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/Auth/login_screen.dart';
import 'package:flutter_firebase/ui/firestore/insert.dart';
import 'package:flutter_firebase/ui/image%20upload/image_upload.dart';
import 'package:flutter_firebase/ui/posts/post_screen.dart';

class SplashServices{

void isLogin(BuildContext context){

  final auth = FirebaseAuth.instance;

  final user = auth.currentUser;   //gives all detailed about currentuser
  if(user != null){
       Timer(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ImageUploadScreen()));
      });
  }
  else{
    Timer(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
  }

 
}

}