import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';

class InsertScreen extends StatefulWidget {
  const InsertScreen({super.key});

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {

  final firestore = FirebaseFirestore.instance.collection("users");
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
                  
                  //creating document under collcetion
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                      "title":postController.text.toString(),
                      "id":id
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                  },).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  },);
                 
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