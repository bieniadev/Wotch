import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/widget/offer_card.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('matches').snapshots();

    return StreamBuilder(
      stream: userRef,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshotMatches = snapshot.data!.docs;
          List<String> firstMatcherIds = [];
          for (var match in snapshotMatches) {
            Map<String, dynamic> matchData = match.data();
            if (matchData['liked_person'] == currentUserId && matchData['active'] == true && matchData['both_matched'] == false) {
              firstMatcherIds.add(matchData['first_matcher']);
            }
          }
          if (firstMatcherIds.isEmpty || firstMatcherIds == null || firstMatcherIds.length == 0) {
            return const Center(
              child: Text(
                'Tu znajdziejsz swoje oferty od innych osób',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: firstMatcherIds.length,
            itemBuilder: (context, index) {
              return OfferCard(documentId: firstMatcherIds[index]);
            },
          );
        }
        return Center(child: Text(snapshot.connectionState.toString()));
      },
    );
  }
}
