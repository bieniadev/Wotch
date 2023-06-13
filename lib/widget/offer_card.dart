import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_match/widget/offer_card_categories.dart';

class OfferCard extends StatefulWidget {
  const OfferCard({super.key, required this.documentId});
  final String documentId;
  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  @override
  Widget build(BuildContext context) {
    CollectionReference userRef = FirebaseFirestore.instance.collection('users');
    return FutureBuilder(
      future: userRef.doc(widget.documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      userData['image_url'],
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          direction: Axis.vertical,
                          children: [
                            Text(userData['firstname'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                            Text('${userData['surname']}, ${userData['age']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        OfferCardCategories(documentId: widget.documentId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
