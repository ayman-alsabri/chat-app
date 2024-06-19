import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  Future<void> _submitToFirebase({
    required String email,
    required String password,
    required String username,
    required bool isLogin,
    required BuildContext context,
    required File? profileImage,
  }) async {
    try {
      final auth = FirebaseAuth.instance;
      UserCredential result;
      if (isLogin) {
        result = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        result = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String? url;
        if (profileImage != null) {
          final ref = FirebaseStorage.instanceFor(
                  bucket: 'gs://my-chat-9a4fb.appspot.com')
              .ref()
              .child('usersImages')
              .child('${result.user!.uid}.jpg');
          await ref.putFile(profileImage);
          url = await ref.getDownloadURL();
        }

        FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set({
          'username': username,
          'email': email,
          'profileUrl': url,
        });
      }
    } on FirebaseAuthException catch (e) {
      var errormessage = 'somthing went wrong';
      if (e.message != null) {
        errormessage = e.message!;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errormessage)));
    } catch (e) {
      // print(e);
      // print(e);
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: AuthForm(_submitToFirebase),
    );
  }
}
