import 'package:flutter/material.dart';
import 'package:work_match/widget/new_messages.dart';
import 'package:work_match/widget/ongoing_messages.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        NewMessages(),
        OngoingMessages(),
      ],
    );
  }
}
