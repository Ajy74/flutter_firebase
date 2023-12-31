import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;  
  bool isCreated = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signup(){
    //to create user on firebase
    _auth.createUserWithEmailAndPassword(
      email: emailController.text.toString(), 
      password: passwordController.text.toString(),
    ).then((value) {
        Utils().toastMessage(value.toString());
        setState(() {
          isCreated=false;
        });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
        setState(() {
          isCreated=false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup Screen"),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          hintText: "password",
                          helperText: "must contain(8 character)",
                          prefixIcon: Icon(
                            Icons.password,
                            color: Colors.deepPurple,
                          )),
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Enter password';
                            }
                            return null;
                          },
                    ),
                  ),
                ],
              )),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RoundButton(width: double.maxFinite,
              title: "Signup",
              loading: isCreated,
               onPress: () {
                  setState(() {
                    isCreated=true;
                  });
                if(_formKey.currentState!.validate()){
                    signup();
                }
              },),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("already have an account?"),
                TextButton(onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                }, 
                child: Text("Login",style: TextStyle(color: Colors.deepPurple),))
              ],
            )
        ],
      ),
    );
  }
}