import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfferCardCategories extends StatelessWidget {
  const OfferCardCategories({super.key, required this.documentId});

  final String documentId;

  @override
  Widget build(BuildContext context) {
    CollectionReference userRef = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: userRef.doc(documentId).collection('user_categories').doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> userDataCategories = snapshot.data!.data() as Map<String, dynamic>;
            List<dynamic> userTechs = userDataCategories['technologies'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: userTechs.map((tech) {
                return Container(
                  margin: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color.fromARGB(255, 236, 236, 236), border: Border.all(color: Theme.of(context).colorScheme.primary)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Text(tech, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary.withOpacity(0.7), fontWeight: FontWeight.bold)),
                );
              }).toList(),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
