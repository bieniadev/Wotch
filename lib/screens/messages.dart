import 'package:flutter/material.dart';
import 'package:work_match/widget/new_messages.dart';
import 'package:work_match/widget/ongoing_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var currentUserId = FirebaseAuth.instance.currentUser;

    return FutureBuilder<List<String>>(
        future: fetchUserIds(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            List<String> userIds = snapshot.data!;

            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NewMessages(
                //   usersIdss: userIds,
                // ),
                OngoingMessages(
                  usersIdss: userIds,
                ),
              ],
            );
          }
          return const Text('Error');
        });
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
