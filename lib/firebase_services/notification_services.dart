import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/notifications/message_screen.dart';
import 'package:flutter_firebase/ui/notifications/notification_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{

  FirebaseMessaging messaging  = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true, //if false notificant won't be show
      announcement: true, 
      badge: true, //for countings
      carPlay: true, 
      criticalAlert: true,
      provisional: true,  //user can able to enable or disable from notification list
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
        //user granted permission
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
         //user granted provisional permission
    }
    else{
        //user denied permission
        
    }

  }

  Future<String> getDeviceToken()async{
    String? token = await messaging.getToken();
    return token! ;
  }

  Future<void> isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refreshed');
      }
    });
  }


  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
        if (kDebugMode) {
          print(message.notification!.title.toString());
          print(message.notification!.body.toString());
          print(message.data.toString());
          print(message.data['id'].toString());
          print(message.data['type'].toString());
        }
        
        if(Platform.isAndroid){
          initLocalNotification(context,message);  //works only for android
        }
        showNotification(message);      //both          
    });
  }

  void initLocalNotification(BuildContext context,RemoteMessage message)async{
      var androidInitialization =const AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitialization =const DarwinInitializationSettings();

      var initializationSetting = InitializationSettings(
        android: androidInitialization,
        iOS: iosInitialization,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(context, message);
        },
        // onDidReceiveBackgroundNotificationResponse: (payload) {
        //   handleMessageBackground(context);
        // },
      );
  }

  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(), 
      'High importance notification',
       importance: Importance.max
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        // Random.secure().nextInt(100000).toString(), 
        // 'High importance notification'
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker'
      );

     const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        //firebase does not use this 
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

    Future.delayed(Duration.zero,() {
      print("%%%%%Isme aaya%%%%");
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      _flutterLocalNotificationsPlugin.show(
        1, 
        message.notification!.title.toString(), 
        message.notification!.body.toString(), 
        notificationDetails,
        payload: "new not"
      );
    },);
  }

  void handleMessage(BuildContext context,RemoteMessage message){
      if(message.data['type']=='alert'){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MessageScreen()));
      }
  }
  void handleMessageBackground(BuildContext context)async{

    //all setings manage by firebase for background
    //when app terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationScreen()));
      handleMessage(context, initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
     });

  }

}