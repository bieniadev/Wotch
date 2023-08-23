import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                if (snapshot.hasError) return const Text('Coś poszło nie tak...');
                if (snapshot.data == null || snapshot.data?.data() == null) return const CircularProgressIndicator();

                return Container(
                  padding: EdgeInsets.only(top: 20 + MediaQuery.of(context).padding.top, bottom: 20),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  child: Column(
                    children: [
                      CircleAvatar(
                        foregroundImage: NetworkImage(snapshot.data!.data()!['image_url']),
                        radius: 52,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        snapshot.data!.data()!['firstname'],
                        style: const TextStyle(fontSize: 26, color: Colors.white),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser!.email as String,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                );
              }),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 70),
            child: ElevatedButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.subdirectory_arrow_right_outlined),
              label: const Text('Wyloguj się'),
            ),
          )
        ],
      ),
    );
  }
}
