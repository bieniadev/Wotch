import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/widget/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.documentId});

  final String documentId;

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;

    if (documentId.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('matches').doc(documentId).collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('Zacznij pierwszy rozmowę!'),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Coś poszło nie tak...'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (context, index) {
              final chatMessage = loadedMessages[index].data();
              final nextChatMeessage = index + 1 < loadedMessages.length ? loadedMessages[index + 1].data() : null;
              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUsernameId = nextChatMeessage != null ? nextChatMeessage['userId'] : null;
              final nextUserIsSame = nextMessageUsernameId == currentMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(message: chatMessage['text'], isMe: authUser.uid == currentMessageUserId);
              } else {
                return MessageBubble.first(userImage: chatMessage['userImage'], username: chatMessage['name'], message: chatMessage['text'], isMe: authUser.uid == currentMessageUserId);
              }
            },
          ),
        );
      },
    );
  }
}
