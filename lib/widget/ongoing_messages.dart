import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/screens/conversation.dart';
import 'package:work_match/widget/conversation_card.dart';

class OngoingMessages extends StatelessWidget {
  const OngoingMessages({super.key, required this.usersIdss});

  final List<String> usersIdss;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser;
    var usersIds = usersIdss;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                child: Text('Tu bedą wyświetlać Ci się aktywne konwersacje'),
              ),
            );
          }

          return Expanded(
            child: ListView.builder(
              itemCount: userMatches.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection('users').doc(usersIds[index]).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      //   final userCheck = FirebaseFirestore.instance.collection('matches').doc(userMatches[index]).collection('chat').get();
                      //   if(userCheck.documents.lenght == 0){

                      //   print(userCheck);
                      //   }

                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationScreen(documentId: usersIds[index]))),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                foregroundImage: NetworkImage(snapshot.data!.data()!['image_url'] as String),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${snapshot.data!.data()!['firstname'] as String} ${snapshot.data!.data()!['surname'] as String}', style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 6),
                                  Text('Ostatnia wiadomosc', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                  //   FirebaseFirestore.instance.collection('matches').doc(documentId).collection('chat').orderBy('createdAt', descending: true).snapshots(),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                      ;
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
    );
  }
}
