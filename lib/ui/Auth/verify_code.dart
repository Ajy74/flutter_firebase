import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/posts/post_screen.dart';
import 'package:flutter_firebase/utils/utils.dart';

import '../../widget/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
 final String verificationId;
  VerifyCodeScreen({super.key,required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  @override
  final verifyCodeController = TextEditingController();
  bool loading =false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("verify"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: Column(
          children: [
              SizedBox(height: 80,),
              TextFormField(
                keyboardType: TextInputType.number,
                controller:verifyCodeController,
                decoration: InputDecoration(
                  hintText: '6 digit code',
                ),
              ),
              SizedBox(height: 80,),
              Container(
                width: double.infinity,
                child: RoundButton(
                  loading: loading,
                  title: "verify", 
                  onPress: () async {
                    setState(() {
                      loading=true;
                    });
                    final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId, 
                      smsCode: verifyCodeController.text.toString()
                    );

                    try {
                      await auth.signInWithCredential(credential);
                      setState(() {
                        loading=false;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> PostScreen()));
                    } catch (e) {
                      setState(() {
                        loading=false;
                      });
                      Utils().toastMessage(e.toString());
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}