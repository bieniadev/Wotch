import 'package:flutter/material.dart';

class UserTextField extends StatefulWidget {
  const UserTextField({super.key, required this.textController, required this.onSubmitChange});
  final TextEditingController textController;
  final void Function() onSubmitChange;

  @override
  State<UserTextField> createState() => UserTextFieldState();
}

class UserTextFieldState extends State<UserTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: widget.textController,
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), suffixIcon: IconButton(onPressed: widget.onSubmitChange, icon: const Icon(Icons.settings)), fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2), filled: true, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2)),
      ),
    );
  }
}
