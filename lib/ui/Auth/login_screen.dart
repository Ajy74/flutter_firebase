import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/ui/Auth/forgot_password.dart';
import 'package:flutter_firebase/ui/Auth/login_with_phone_number.dart';
import 'package:flutter_firebase/ui/Auth/signup_screen.dart';
import 'package:flutter_firebase/ui/posts/post_screen.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool isCreated = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login(){
    _auth.signInWithEmailAndPassword(
      email: emailController.text.toString(), password: passwordController.text.toString()
    ).then((value) {
        Utils().toastMessage(value.user!.email.toString());
        setState(() {
          isCreated=false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
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
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();  //to exit app
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login Screen"),
          automaticallyImplyLeading: false,
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
                child: RoundButton(width: double.maxFinite,title: "Login",
                loading: isCreated,
                 onPress: () {
                   setState(() {
                        isCreated=true;
                  });
                  if(_formKey.currentState!.validate()){
                      //to login user
                      login();
                  }
                },),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupScreen()));
                  }, 
                  child: Text("Sign up",style: TextStyle(color: Colors.deepPurple),))
                ],
              ),

              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPasswordScreen()));
                  }, 
                  child: Text("Forgot password",style: TextStyle(color: Colors.deepPurple),))
                ],
              ),

              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => LoginWithPhoneNumber()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.deepPurple)
                    ),
                    child: Center(
                      child: Text('Login with phone number'),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}