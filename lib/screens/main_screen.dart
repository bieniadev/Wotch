import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/screens/search.dart';
import 'package:work_match/screens/messages.dart';
import 'package:work_match/screens/offer.dart';
import 'package:work_match/screens/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPageIndex = 1;
  final pageController = PageController(initialPage: 1);

  final user = FirebaseAuth.instance.currentUser!;

  _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      pageController.jumpToPage(_selectedPageIndex);
    });
  }

  _selectPageByScroll(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePageSelectIcon = IconButton(
      onPressed: () {},
      icon: Icon(Icons.hourglass_empty_sharp, color: Theme.of(context).colorScheme.primary),
    );

    if (_selectedPageIndex == 0) {
      activePageSelectIcon = IconButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        icon: Icon(
          Icons.exit_to_app,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
      );
    }

    if (_selectedPageIndex == 1) {
      activePageSelectIcon = IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.settings_input_composite_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
      );
    }
    if (_selectedPageIndex == 2) {
      activePageSelectIcon = IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.settings_input_composite_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
      );
    }
    if (_selectedPageIndex == 3) {
      activePageSelectIcon = IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.settings_input_composite_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wotch', style: TextStyle(fontSize: 28)),
        actions: [activePageSelectIcon],
      ),
      body: PageView(
        physics: _selectedPageIndex == 1 ? const NeverScrollableScrollPhysics() : null,
        controller: pageController,
        onPageChanged: _selectPageByScroll,
        pageSnapping: true,
        children: const [
          ProfileScreen(),
          SearchScreen(),
          OffersScreen(),
          MessagesScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.85),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: GNav(
            onTabChange: _selectPage,
            selectedIndex: _selectedPageIndex,
            iconSize: 26,
            gap: 8,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              GButton(icon: Icons.person, text: 'Profil'),
              GButton(icon: Icons.search, text: 'Szukaj'),
              GButton(icon: Icons.home_repair_service_rounded, text: 'Oferty'),
              GButton(icon: Icons.message_rounded, text: 'Czat'),
            ],
          ),
        ),
      ),
    );
  }
}
