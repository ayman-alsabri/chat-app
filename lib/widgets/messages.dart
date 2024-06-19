import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  

  DateFormat _pattern(MediaQueryData mediaQuery, Timestamp timestamp) {
    final dateStamp = timestamp.toDate();
    final currentDate = DateTime.now();

    if (dateStamp.year < currentDate.year) {
      return  DateFormat.yM(); 
    }
    if (dateStamp.month < currentDate.month) {
      return  DateFormat.MMMMd(); 
    }
    if ((dateStamp.weekday == 5 ? 7 : (dateStamp.weekday + 2) % 7) <
            (currentDate.weekday == 5 ? 7 : (currentDate.weekday + 2) % 7) &&
        currentDate.day - dateStamp.day < 7) {
      return mediaQuery.alwaysUse24HourFormat ? DateFormat.E().add_Hm():DateFormat.E().add_jm();
    }
    if (dateStamp.day == currentDate.day) {
      return mediaQuery.alwaysUse24HourFormat ? DateFormat.Hm(): DateFormat.jm();
    }

    return DateFormat.MMMd();
  }

  

  @override
  Widget build(BuildContext context) {
    
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/chat')
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs;

              if (docs == null) {
                return FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '   No messages yet   ',
                    style: TextStyle(fontSize: 300, color: theme.disabledColor),
                  ),
                );
              }
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(
                          profileUrl:docs[index].data()['profileUrl'],
                          userName: docs[index].data()['username'],
                          text: docs[index].data()['text'],
                          isMe: user.uid == docs[index].data()['uid'],
                          key: UniqueKey(),
                          timestamp:  docs[index].data()['timeStamp'],
                           pattern:_pattern(mediaQuery, docs[index].data()['timeStamp']) ,
                        );
                      });
            });
  }
}
