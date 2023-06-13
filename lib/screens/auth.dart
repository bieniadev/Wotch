import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:work_match/modals/enums.dart';
import 'package:work_match/widget/login_form.dart';
import 'package:work_match/widget/register_form.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenStateEs();
}

class _AuthScreenStateEs extends State<AuthScreen> {
  var _isLogin = true;

  void onChangeForms() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future _registerUser({
    required String firstname,
    required String surname,
    required String email,
    required String age,
    required String password,
    required bool selectedProfile,
    required File? image,
  }) async {
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final storageRef = FirebaseStorage.instance.ref().child('user_images').child('${userCredentials.user!.uid}.jpg');
      await storageRef.putFile(image!);

      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
        'firstname': firstname,
        'surname': surname,
        'age': age,
        'email': email,
        'image_url': imageUrl,
        'role': selectedProfile ? UserRolesHelper.getValue(UserRoles.employee) : UserRolesHelper.getValue(UserRoles.employer),
        'active': false,
        'likes': [],
        'matches': [],
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Błąd autoryzacji.'),
      ));
    }
  }

  Future _loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Błąd autoryzacji.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Text(
                'Work match',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 48,
                ),
              ),
              _isLogin
                  ? LoginForm(
                      changeForms: onChangeForms,
                      login: _loginUser,
                    )
                  : RegisterForm(
                      changeForms: onChangeForms,
                      register: _registerUser,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
