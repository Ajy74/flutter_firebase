import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {

  //for getting file
  File? _image ;
  final picker = ImagePicker();
  
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  CollectionReference db  = FirebaseFirestore.instance.collection('users');
  final snapshot  = FirebaseFirestore.instance.collection('users').snapshots();

  Future getGalleryImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    setState(() {
      if(pickedFile != null){
       _image = File(pickedFile.path);
      //  print("file path----->${_image!.absolute.toString()}");
      }
      else{
       Utils().toastMessage("please pick image");
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ),
                child: _image!=null ? Center(child: Image.file(_image!),) : Center(child: Icon(Icons.image)),
              ),
            ),
      
            SizedBox(height: 30,),
      
            RoundButton(
              title: "upload",
              onPress: ()async {
              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/foldername/'+DateTime.now().millisecondsSinceEpoch.  toString());
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

              await Future.value(uploadTask).then((value) async{

                var newUrl = await ref.getDownloadURL();
              
                //to upload above image url into db
                db.doc("1687175875628093").collection("profile").doc(DateTime.now().millisecondsSinceEpoch.  toString()).set({
                 "id":DateTime.now().millisecondsSinceEpoch.toString(),
                 "profile_img":newUrl.toString()
                }).then((value) => Utils().toastMessage("image uploaded"));
              });

            },)
      
          ],
        ),
      ),
    );
  }
}