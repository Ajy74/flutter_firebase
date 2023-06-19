import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final databaseRef = FirebaseDatabase.instance.ref('Post');
  bool loading = false;
  final postController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: Column(
          children: [
             SizedBox(height: 30,),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: postController,
              decoration: InputDecoration(
                hintText: "what's in your mind?",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 30,),
            Container(
              width: double.infinity,
              child: RoundButton(
                title: "Add", 
                loading: loading,
                onPress:() {
                  setState(() {
                    loading = true;
                  });

                  databaseRef.child(DateTime.now().microsecondsSinceEpoch.toString()).set({
                    'id':1,
                    'title':postController.text.toString()
                 }).then((value) {
                    Utils().toastMessage("Post added");
                    
                 }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                   setState(() {
                    loading = false;
                  });
                 });
                   setState(() {
                    loading = false;
                   });
                } ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}