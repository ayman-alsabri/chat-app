import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart' ;


Future<void> handler(RemoteMessage message) async{
  // print('form handler');
 }


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

 
 
  @override
void initState (){
   
  FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(handler);
  FirebaseMessaging.onMessage.listen( (RemoteMessage message) {

  // print('Got a message whilst in the foreground!');
  // print('Message data: ${message.notification?.body} ');

  if (message.notification != null) {
    // print('Message also contained a notification:');
  }
  setState(() {
    
  });
});
 super.initState();
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter chat'),
        actions: [
          DropdownButton(
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ))
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon:  Icon(Icons.more_vert,color:theme.colorScheme.onBackground,),
          )
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: Messages()),
          SendMessage()
        ],
      ),
    );
  }
}
