import 'dart:ffi';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:work_match/widget/select_profile.dart';
import 'package:work_match/widget/user_image_picker.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.changeForms,
    required this.register,
  });

  final void Function() changeForms;
  final Future Function({
    required String firstname,
    required String surname,
    required String age,
    required String email,
    required String password,
    required bool selectedProfile,
    required File? image,
  }) register;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _form = GlobalKey<FormState>();

  var _selectedProfile = true;
  File? _selectedImage;
  var _enteredFirstname = '';
  var _enteredSurname = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredAge = '1';
  var _isAuthenticating = false;

  void _onChangeProfile() {
    setState(() {
      _selectedProfile = !_selectedProfile;
    });
  }

  void _onSubmit() async {
    setState(() {
      _isAuthenticating = true;
    });

    final isValid = _form.currentState!.validate();
    if (!isValid || _selectedImage == null) {
      setState(() {
        _isAuthenticating = false;
      });
      return;
    }
    _form.currentState!.save();

    await widget.register(
      email: _enteredEmail,
      password: _enteredPassword,
      firstname: _enteredFirstname,
      surname: _enteredSurname,
      selectedProfile: _selectedProfile,
      image: _selectedImage,
      age: _enteredAge,
    );
    _isAuthenticating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserImagePicker(
                    onPickImage: (pickedImage) {
                      _selectedImage = pickedImage;
                    },
                  ),
                  TextFormField(
                      decoration: const InputDecoration(labelText: 'Imię'),
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().length < 2 || value.isEmpty) {
                          return 'Imię musi mieć co najmniej 2 znaki.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredFirstname = value!;
                      }),
                  TextFormField(
                      decoration: const InputDecoration(labelText: 'Nazwisko'),
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().length < 2 || value.isEmpty) {
                          return 'Nazwisko musi mieć co najmniej 2 znaki.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredSurname = value!;
                      }),
                  TextFormField(
                      decoration: const InputDecoration(labelText: 'Wiek'),
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prosze podać poprawną wartość';
                        }
                        var age = int.tryParse(value);
                        if (age == null) {
                          return 'Prosze podać poprawną wartość';
                        }
                        if (age <= 18) {
                          return 'Musisz mieć skończone co najmniej 18 lat';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _enteredAge = value!;
                      }),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Adres Email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty || !value.contains('@')) {
                        return 'Prosze podać poprawny adres email.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredEmail = value!;
                    },
                  ),
                  SelectProfile(
                    changeProfile: _onChangeProfile,
                    selectedProfile: _selectedProfile,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Hasło'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return 'Hasło musi mieć co najmniej 6 znaki.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredPassword = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      if (_isAuthenticating) const CircularProgressIndicator(),
                      if (!_isAuthenticating)
                        ElevatedButton(
                          onPressed: _onSubmit,
                          child: const Text('Zarejestruj się'),
                        ),
                      TextButton(
                        onPressed: widget.changeForms,
                        child: const Text('Zaloguj się tutaj'),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
