import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  var _editedmessage = '';
  final _textController = TextEditingController();

  void _sendTheMessage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final username = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    FirebaseFirestore.instance.collection('/chat').add({
      'text': _editedmessage,
      'timeStamp': Timestamp.now(),
      'uid':uid,
      'username':  username.data()!['username'],
      'profileUrl':username.data()!['profileUrl']
    });
    if(!mounted)return;
    FocusScope.of(context).unfocus();
    _textController.clear();
    setState(() {
      _editedmessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 0,
            color: theme.colorScheme.primary.withOpacity(0.3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing',
                ),
                onChanged: (value) {
                  setState(() {
                    _editedmessage = value;
                  });
                },
              ),
            ),
          ),
        ),
        IconButton(
          color: theme.colorScheme.primary.withOpacity(0.7),
          onPressed: _editedmessage.trim().isEmpty ? null : _sendTheMessage,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
