import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final Timestamp timestamp;
  final DateFormat pattern;
  final String userName;
  final String? profileUrl;
  const MessageBubble(
      {super.key,
      required this.pattern,
      required this.userName,
      required this.text,
      required this.isMe,
      required this.profileUrl,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints:
                  BoxConstraints(maxWidth: mediaQuery.size.width * 0.6),
              decoration: BoxDecoration(
                color: isMe
                    ? theme.colorScheme.primary.withOpacity(0.5)
                    : theme.colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: isMe
                      ? const Radius.circular(10)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(10),
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: isMe
                        ? AlignmentDirectional.topStart
                        : AlignmentDirectional.topEnd,
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              userName,
                              style: TextStyle(
                                color: isMe
                                    ? theme.colorScheme.tertiary
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            text,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 17 * mediaQuery.textScaleFactor),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -30,
                        left: isMe ? -30 : null,
                        right: isMe ? null : -30,
                        child: CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(0.5),
                          backgroundImage: profileUrl == null
                              ? const AssetImage('assets/images/image.png')
                                  as ImageProvider
                              : NetworkImage(profileUrl!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                pattern.format(timestamp.toDate()),
                style: TextStyle(
                    color: theme.disabledColor,
                    fontSize: 10 * mediaQuery.textScaleFactor),
              ),
            )
          ],
        ),
      ],
    );
  }
}
