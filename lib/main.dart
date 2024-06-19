import 'dart:io';

import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          // name: 'myChat',
          options: const FirebaseOptions(
            apiKey: 'AIzaSyDj2WOYAMtXqHhZnMk91dbq2tu6Eo6s0po',
            appId: '1:584698098616:android:42a20a826622c71ac2154d',
            messagingSenderId: '584698098616',
            projectId: 'my-chat-9a4fb',
            // storageBucket: 'gs://my-chat-9a4fb.appspot.com',
          ))
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red, brightness: Brightness.light),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) =>
            snapshot.hasData ? const ChatScreen() : const AuthScreen(),
      ),
    );
  }
}

