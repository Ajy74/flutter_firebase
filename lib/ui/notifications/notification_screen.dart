import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_services/notification_services.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); 
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.handleMessageBackground(context);
  
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print("device token->${value.toString()}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            //to send notification from one device to another.....here my selfdevice
            notificationServices.getDeviceToken().then((value) async{
              print(value.toString());
              var data = {
                'to' : value.toString(),  //device token of reciever device
                'priority' : 'high',
                'notification':{
                  'title':'Ajay',
                  'body' : 'Testing Message by Ajay',
                },
                //here this is used to redirect
                'data':{
                  'type':'alert',
                  'id':'Ajay1234',
                  //any parameter we can send as or need//
                }
              };
              final response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  body: jsonEncode(data),
                  headers: {
                    'Content-Type':'application/json; charset=UTF-8',
                    'Authorization': 'Bearer AAAAFY9rdTY:APA91bGL4PZ6bOB3VwXG32miM33TNRU2c66T1dnzRQW90JmYBYOoTny-87RvgGMWgtndu-s-9rwMJSLcgh_7tAZXBLfw61EEOzI6emQkID7c5c0HzIyqsGv8PdW3wi6FiehGpubCNgXp',
                  }
              );
              print("${response.statusCode}");
            } );

          }, 
          child: Text("send notification")

        ),
      ),
    );
  }
}