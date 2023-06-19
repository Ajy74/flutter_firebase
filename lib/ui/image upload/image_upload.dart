import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider ;

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {

  //for getting file
  File? _image ;
  final picker = ImagePicker();

  File? newPath; //to compreesion use
  XFile? newImage ;  //to compreesion use
  
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  CollectionReference db  = FirebaseFirestore.instance.collection('users');
  final snapshot  = FirebaseFirestore.instance.collection('users').snapshots();

  Future getGalleryImage() async{
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);


    //for compression code
    newImage = await picker.pickImage(source: ImageSource.gallery);
    final bytes  = await newImage!.readAsBytes();
    final kb = bytes.length /1024;
    final mb = kb/1024;
    if(kDebugMode){
      print("origininal image size = "+mb.toString());
    }
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';
       //now converting original to compress//
    final result = await FlutterImageCompress.compressAndGetFile(
      newImage!.path,
      targetPath,
      minHeight: 1080, //this can be change by need
      minWidth: 1080,
      quality: 50, //keep this high to get the original quality of image
    );
    
    final data = await result!.readAsBytes();
    final newKb = data.length/1024;
    final newMb = newKb/1024;
    if(kDebugMode){
      print("compressed image size = "+newMb.toString());
    }

    newPath = File(result!.path) ;
    //for compression code end


    // setState(() {
    //   if(pickedFile != null){
    //    _image = File(pickedFile.path);
    //   //  print("file path----->${_image!.absolute.toString()}");
    //   }
    //   else{
    //    Utils().toastMessage("please pick image");
    //   }
    // });
    setState(() {
      if(newPath != null){
       _image = File(newPath!.path);
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
                // child: _image!=null ? Center(child: Image.file(_image!),) : Center(child: Icon(Icons.image)),
                child: _image!=null ? Center(child: Image.file(newPath!),) : Center(child: Icon(Icons.image)),
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