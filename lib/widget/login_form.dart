import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.changeForms, required this.login});

  final void Function() changeForms;
  final Future Function({
    required String email,
    required String password,
  }) login;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _form = GlobalKey<FormState>();

  var _enteredPassword = '';
  var _enteredEmail = '';
  var _isAuthenticating = false;

  void _onSubmit() async {
    setState(() {
      _isAuthenticating = true;
    });
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      setState(() {
        _isAuthenticating = false;
      });
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isAuthenticating = false;
    });
    await widget.login(
      email: _enteredEmail,
      password: _enteredPassword,
    );
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
                  const SizedBox(height: 4),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Hasło'),
                    obscureText: true, // cenzura wpisywanego tekstu
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
                          child: const Text('Zaloguj się'),
                        ),
                      TextButton(
                        onPressed: widget.changeForms,
                        child: const Text('Zarejestruj się tutaj'),
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
