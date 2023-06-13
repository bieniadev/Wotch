import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class MatchedPopup extends StatelessWidget {
  const MatchedPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Powiązanie!', style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      content: const Text('Udało Ci się znaleść osobę, która jest tobą zainteresowana!!'),
      actions: [ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Świetnie!'))],
    );
  }
}
