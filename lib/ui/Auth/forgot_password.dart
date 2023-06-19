import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

 
  final emailController = TextEditingController();
  
  final _auth = FirebaseAuth.instance;
  bool isCreated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("forgot password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
           TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                            hintText: "email",
                            helperText: "enter email e.g jon@gmail.com",
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: Colors.deepPurple,
                            )),
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Enter Email';
                              }
                              return null;
                            },
                      ),

                      SizedBox(height: 80,),

                      RoundButton(title: "Recover", onPress: () {
                        //for email reset link
                        _auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                              Utils().toastMessage("we have sent you mail to recover password");
                        }).onError((error, stackTrace) {
                           Utils().toastMessage("something went wrong");
                        });
                      },),
          ],
        ),
      ),
    ) ;
  }
}