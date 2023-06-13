import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SelectProfile extends StatefulWidget {
  const SelectProfile({super.key, required this.changeProfile, required this.selectedProfile});

  final void Function() changeProfile;
  final bool selectedProfile;

  @override
  State<SelectProfile> createState() => _SelectProfileState();
}

class _SelectProfileState extends State<SelectProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pracodawca',
            style: TextStyle(
              color: !widget.selectedProfile ? Theme.of(context).colorScheme.primary : null,
              fontWeight: FontWeight.bold,
            ),
          ),
          FlutterSwitch(
            value: widget.selectedProfile,
            onToggle: (value) => widget.changeProfile(),
            inactiveColor: Theme.of(context).colorScheme.primary,
            activeColor: Theme.of(context).colorScheme.primary,
            width: 60.0,
            duration: const Duration(milliseconds: 100),
          ),
          Text(
            'Pracownik',
            style: TextStyle(
              color: widget.selectedProfile ? Theme.of(context).colorScheme.primary : null,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
