import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserCategories extends StatelessWidget {
  const GetUserCategories({super.key, required this.documentId});

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
          return Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 14, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: userTechs.map((tech) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10, bottom: 14),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color.fromARGB(255, 236, 236, 236), border: Border.all(color: Theme.of(context).colorScheme.primary)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Text(tech, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary.withOpacity(0.7), fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    const Text('Wykształcenie: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      userDataCategories['experience'],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Doświadczenie: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      userDataCategories['degree'],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                userDataCategories['company_size'] != null
                    ? Row(
                        children: [
                          const Text('Wielkość firmy: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            userDataCategories['company_size'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
