import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/screens/conversation.dart';

class NewMessages extends StatelessWidget {
  const NewMessages({Key? key, required this.usersIdss}) : super(key: key);

  final List<String> usersIdss;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser;
    var usersIds = usersIdss;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(currentUserId!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final userMatches = (snapshot.data!.data()!['matches'] as List<dynamic>).cast<String>();
            if (usersIds.isEmpty) {
              return const SizedBox(
                height: 120,
                child: Center(
                  child: Text('Aktualnie nie masz żadnych nowych konwersacji.'),
                ),
              );
            }

            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userMatches.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance.collection('users').doc(usersIds[index]).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationScreen(documentId: usersIds[index]))),
                                  child: CircleAvatar(
                                    radius: 40,
                                    foregroundImage: NetworkImage(snapshot.data!.data()!['image_url'] as String),
                                  )),
                              const SizedBox(height: 5),
                              Text(snapshot.data!.data()!['firstname'] as String),
                            ],
                          ),
                        );
                      }

                      return const Text('Error');
                    },
                  );
                },
              ),
            );
          }
          return const Text('Error');
        },
      ),
    );
  }
}
