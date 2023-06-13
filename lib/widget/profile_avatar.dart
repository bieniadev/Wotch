import 'package:flutter/material.dart';
import 'package:work_match/screens/photo_selector.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key, required this.userPhotoUrl});

  final String userPhotoUrl;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CircleAvatar(
          radius: 80,
          foregroundImage: NetworkImage(widget.userPhotoUrl),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PhotoSelectorScreen()));
          },
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 7,
              ),
            ]),
            padding: const EdgeInsets.all(14),
            child: const Icon(
              Icons.edit,
              color: Color.fromARGB(255, 101, 101, 101),
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}
