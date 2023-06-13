import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/widget/chat_messages.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.documentId});

  final String documentId;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _messageController = TextEditingController();

  final currentUserid = FirebaseAuth.instance.currentUser!.uid;

  String currentMatch = '';

  Future _getMatchId() async {
    final matchesRef = FirebaseFirestore.instance.collection('matches');
    QuerySnapshot<Map<String, dynamic>> getMatches = await matchesRef.get();
    final query = getMatches.docs;

    for (var match in query) {
      if (match.data()['first_matcher'] == currentUserid && match.data()['liked_person'] == widget.documentId && match.data()['both_matched']) {
        setState(() {
          currentMatch = match.id;
        });
      } else if (match.data()['first_matcher'] == widget.documentId && match.data()['liked_person'] == currentUserid && match.data()['both_matched']) {
        setState(() {
          currentMatch = match.id;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getMatchId();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    FirebaseFirestore.instance.collection('matches').doc(currentMatch).collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'name': userData.data()!['firstname'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRef = FirebaseFirestore.instance.collection('users').doc(widget.documentId);

    return Scaffold(
      appBar: AppBar(
          title: FutureBuilder(
        future: userRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
          if (snapshot.hasError) return const Text('Coś poszło nie tak...');
          if (snapshot.data == null || snapshot.data?.data() == null) return const CircularProgressIndicator();

          return Row(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(snapshot.data!.data()!['image_url']),
              ),
              const SizedBox(width: 7),
              Text(snapshot.data!.data()!['firstname']),
            ],
          );
        },

        //    const Text('xddsadas');
      )),
      body: Padding(
        padding: const EdgeInsets.only(left: 14, right: 2, bottom: 14),
        child: Column(
          children: [
            ChatMessages(documentId: currentMatch),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(labelText: 'Wyślij wiadomość...'),
                  ),
                ),
                IconButton(
                  onPressed: _submitMessage,
                  icon: const Icon(Icons.send),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
