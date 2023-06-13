import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:work_match/screens/splash.dart';
import 'package:work_match/widget/get_user_data.dart';
import 'package:work_match/widget/matched_popup.dart';

class SwipeableCards extends StatefulWidget {
  const SwipeableCards({super.key});

  @override
  State<SwipeableCards> createState() => _SwipeableCardsState();
}

class _SwipeableCardsState extends State<SwipeableCards> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> usersIds = [];
  String currentUserRole = '';
  List<String> likedPersonIds = [];
  List<String> firstMatcherIds = [];
  List<String> userLikes = [];
  List<String> userMatchIds = [];
  int _index = 0;
  List<Map<String, dynamic>> matchesData = [];

  Future getUsersId() async {
    DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    Map<String, dynamic>? currentUserData = currentUserSnapshot.data() as Map<String, dynamic>?;
    if (currentUserData != null) {
      currentUserRole = currentUserData['role'];
      userLikes = List<String>.from(currentUserData['likes']);
      userMatchIds = List<String>.from(currentUserData['matches']);
    } else {
      // Okys
      return;
    }

    QuerySnapshot matchesSnapshot = await FirebaseFirestore.instance.collection('matches').get();
    List<QueryDocumentSnapshot> matchesDocuments = matchesSnapshot.docs;

    for (var matchDocument in matchesDocuments) {
      Map<String, dynamic>? match = matchDocument.data() as Map<String, dynamic>?;
      if (match != null) {
        firstMatcherIds.add(match['first_matcher']);
        likedPersonIds.add(match['liked_person']);
        matchesData.add(match);
      }
    }

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<QueryDocumentSnapshot> userDocuments = usersSnapshot.docs;

    for (var document in userDocuments) {
      String currentlyShowingId = document.reference.id;
      Map<String, dynamic>? userData = document.data() as Map<String, dynamic>?;
      if (userData != null && currentUserId != currentlyShowingId && currentUserRole != userData['role']) {
        if (likedPersonIds.contains(currentlyShowingId) && firstMatcherIds.contains(currentUserId) && userLikes.contains(currentlyShowingId)) {
          continue;
        }
        usersIds.add(currentlyShowingId);
      }
    }

    for (var match in matchesData) {
      String currentlyShowingId = match['liked_person'];

      if (match['liked_person'] == currentlyShowingId && match['active'] == false && match['first_matcher'] == currentUserId) {
        usersIds.remove(match['liked_person']);
      }
      if (userLikes.contains(usersIds[_index])) {
        usersIds.remove(usersIds[_index]);
      }
    }
  }

  Future onSwipeRight() async {
    QuerySnapshot matchesSnapshot = await FirebaseFirestore.instance.collection('matches').get();
    List<QueryDocumentSnapshot> matchesDocuments = matchesSnapshot.docs;
    bool flag = false;

    for (var match in matchesDocuments) {
      Map<String, dynamic> matchData = match.data() as Map<String, dynamic>;
      String firstMatcherId = matchData['first_matcher'];
      String likedPersonId = matchData['liked_person'];

      if (firstMatcherId == usersIds[_index] && likedPersonId == currentUserId) {
        // dopasowanie pary
        showDialog(context: context, builder: (context) => MatchedPopup());
        String matchId = match.id;
        userMatchIds.add(matchId);
        Map<String, dynamic> updatedMatchData = {
          ...matchData,
          'both_matched': true,
        };

        await FirebaseFirestore.instance.collection('matches').doc(matchId).set(updatedMatchData);
        userLikes.add(usersIds[_index]);
        await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
          'likes': userLikes,
          'matches': userMatchIds,
        });
        await FirebaseFirestore.instance.collection('users').doc(usersIds[_index]).update({
          'matches': userMatchIds,
        });
        _index++;
        flag = true;
      }
    }
    if (flag == false) {
      await FirebaseFirestore.instance.collection('matches').add({
        'active': true,
        'first_matcher': currentUserId,
        'liked_person': usersIds[_index],
        'both_matched': false,
      });

      userLikes.add(usersIds[_index]);
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({'likes': userLikes});
      _index++;
    }
  }

  Future onSwipeLeft() async {
    QuerySnapshot matchesSnapshot = await FirebaseFirestore.instance.collection('matches').get();
    List<QueryDocumentSnapshot> matchesDocuments = matchesSnapshot.docs;
    bool flag = false;

    for (var match in matchesDocuments) {
      Map<String, dynamic> matchData = match.data() as Map<String, dynamic>;
      String firstMatcherId = matchData['first_matcher'];
      String likedPersonId = matchData['liked_person'];
      if (firstMatcherId == usersIds[_index] && likedPersonId == currentUserId) {
        String matchId = match.id;
        await FirebaseFirestore.instance.collection('matches').doc(matchId).set({
          'active': false,
          'first_matcher': currentUserId,
          'liked_person': usersIds[_index],
        });

        flag = true;
        _index++;
      }
    }
    if (flag == false) {
      await FirebaseFirestore.instance.collection('matches').doc().set({
        'active': false,
        'first_matcher': currentUserId,
        'liked_person': usersIds[_index],
      });
      _index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsersId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          //   if (snapshot.hasData) {}
          if (usersIds.isEmpty) {
            return const Center(
              child: Text(
                'Aklutalnie nie ma żadnych dostępnych profili, bądź wszystkie już przejrzałeś...',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            );
          }
          return AppinioSwiper(
            cardsCount: usersIds.length,
            swipeOptions: AppinioSwipeOptions.horizontal,
            maxAngle: 60,
            allowUnswipe: false,
            onSwipe: (index, direction) {
              if (direction == AppinioSwiperDirection.right) {
                onSwipeRight();
              }
              if (direction == AppinioSwiperDirection.left) {
                onSwipeLeft();
              }
            },
            cardsBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 7, spreadRadius: 2, offset: Offset(0, 3))], borderRadius: BorderRadius.circular(6)),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.grey,
                  child: GetUserName(documentId: usersIds[index]),
                ),
              );
            },
          );

          //   return Text('test');
        }
        return const Center(child: Text('Brak połączenia'));
      },
    );
  }
}
