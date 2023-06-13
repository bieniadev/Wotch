import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:work_match/screens/auth.dart';
import 'package:work_match/screens/continue_register.dart';
import 'package:work_match/screens/main_screen.dart';

import 'firebase_options.dart';
import 'package:work_match/screens/splash.dart';
// import 'package:work_match/screens/home.dart';
// import 'package:work_match/screens/auth2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // // dodaj jesli sie zawiesi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 137, 236, 130)),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data?.data() == null) return const SplashScreen();
                if (!snapshot.data!.data()!['active']) return const ContinueRegisterScreen();

                return const MainScreen();
              },
            );
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
