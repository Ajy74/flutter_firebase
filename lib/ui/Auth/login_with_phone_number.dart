import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/Auth/verify_code.dart';
import 'package:flutter_firebase/widget/round_button.dart';

import '../../utils/utils.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  final phoneNumberController = TextEditingController();
  bool loading =false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: Column(
          children: [
              SizedBox(height: 80,),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                decoration: InputDecoration(
                  hintText: '+91 1234567890',
                ),
              ),
              SizedBox(height: 80,),
              Container(
                width: double.maxFinite,
                child: RoundButton(
                  loading: loading,
                  title: "Get OTP", onPress: () {
                    setState(() {
                      loading= true;
                    });
                    auth.verifyPhoneNumber(
                      phoneNumber: "+91 ${phoneNumberController.text}",
                      verificationCompleted: (_){
                        setState(() {
                          loading= false;
                        });
                      }, 
                      verificationFailed: (error) {
                        setState(() {
                          loading= false;
                        });
                        Utils().toastMessage(error.toString());
                      }, 
                      codeSent: (String verificationId, int? token) {
                        setState(() {
                          loading= false;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyCodeScreen(verificationId: verificationId)));
                      }, 
                      codeAutoRetrievalTimeout: (error) {
                        setState(() {
                          loading= false;
                        });
                        Utils().toastMessage(error.toString());
                      }, 
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}