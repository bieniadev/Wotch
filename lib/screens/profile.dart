import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/screens/bio.dart';
import 'package:work_match/screens/splash.dart';
import 'package:work_match/widget/profile_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();

    return StreamBuilder(
      stream: userRef,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const SplashScreen();
        if (snapshot.hasError) return const Text('Coś poszło nie tak...');

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            UserAvatar(userPhotoUrl: snapshot.data!.data()!['image_url']),
            const SizedBox(height: 20),
            Text(user.email as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data!.data()!['firstname'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  snapshot.data!.data()!['surname'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  snapshot.data!.data()!['age'],
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangeBioScreen()));
              },
              child: const Text('Zmień opis', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
    ;
  }
}
