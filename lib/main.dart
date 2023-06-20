import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_flutterMessagingBackgroundHandler);  //to handle background message
  runApp(const MyApp());
}

//background notification handler
@pragma('vm:entry-point')
Future<void> _flutterMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  if (kDebugMode) {
    print(message.notification!.title.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Integration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home:SplashScreen(),
    );
  }
}

