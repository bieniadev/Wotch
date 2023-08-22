import 'package:flutter/material.dart';

class ConversationCard extends StatelessWidget {
  const ConversationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //   onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConversationScreen())),
      child: Row(
        children: [
          const CircleAvatar(radius: 50),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Imie Nazwisko', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              Text('Ostatnia wiadomosc', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          )
        ],
      ),
    );
  }
}
