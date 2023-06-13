import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/screens/conversation.dart';

class NewMessages extends StatelessWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUserId = FirebaseAuth.instance.currentUser;

    return FutureBuilder<List<String>>(
      future: fetchUserIds(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        // else if (snapshot.hasError) {
        //   return const Text('Nie masz żadnych maczy do teraz '); // poprawic
        // }
        else if (snapshot.hasData) {
          List<String> userIds = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('users').doc(currentUserId!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final userMatches = (snapshot.data!.data()!['matches'] as List<dynamic>).cast<String>();

                  if (userIds.isEmpty) {
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
                        // print(userIds);
                        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance.collection('users').doc(userIds[index]).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationScreen(documentId: userIds[index]))),
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
        return const Text('kys yks');
      },
    );
  }

  Future<List<String>> fetchUserIds(User? currentUserId) async {
    List<String> userIds = [];

    final snapshot = await FirebaseFirestore.instance.collection('users').doc(currentUserId!.uid).get();
    final userMatches = (snapshot.data()!['matches'] as List<dynamic>).cast<String>();

    for (var match in userMatches) {
      String userId = await getUserId(match);
      userIds.add(userId);
    }

    return userIds;
  }

  Future<String> getUserId(String currentMatchId) async {
    DocumentSnapshot<Map<String, dynamic>> match = await FirebaseFirestore.instance.collection('matches').doc(currentMatchId).get();
    String userId = '';
    if (match['first_matcher'] == FirebaseAuth.instance.currentUser!.uid) {
      userId = match['liked_person'] as String;
    } else if (match['liked_person'] == FirebaseAuth.instance.currentUser!.uid) {
      userId = match['first_matcher'] as String;
    }
    return userId;
  }
}
