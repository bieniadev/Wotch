import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:work_match/modals/enums.dart';

class ChangeBioScreen extends StatefulWidget {
  const ChangeBioScreen({super.key});

  @override
  State<ChangeBioScreen> createState() => _ChangeBioScreenState();
}

var _selectedCategoryExperience; //default kategoria / kategoria wybrana wcześniej
var _selectedCategoryDegree;
var _selectedCompanySize;
List<String> _avaiableTechs = CategoryTechnologyHelper.getValues();
List<String> _selectedTechnology = [];
// int _selectegAge = 0;
bool _isSubmiting = false;

class _ChangeBioScreenState extends State<ChangeBioScreen> {
  final user = FirebaseAuth.instance.currentUser!;
//   void _onSubmit() async {
//     setState(() {
//       _isSubmiting = true;
//     });
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('user_categories').doc(user.uid).set({
//         'experience': CategoryExperienceHelper.getValue(_selectedCategoryExperience),
//         'degree': CategoryDegreeHelper.getValue(_selectedCategoryDegree),
//         'company size': CategoryCompanySizeHelper.getValue(_selectedCompanySize),
//         // 'age': _selectegAge,
//         'technologies': _selectedTechnology,
//       });
//       setState(() {
//         _isSubmiting = false;
//       });
//     } on FirebaseAuthException catch (error) {
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(error.message ?? 'Błąd autoryzacji.'),
//       ));
//     }
//     Navigator.of(context).pop();
//     setState(() {
//       _isSubmiting = false;
//     });
//   }

  void _onSubmitEmployer() async {
    if (_selectedTechnology.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wybierz co najmniej 1 tag')));
      return;
    }
    if (_selectedTechnology.length > 3) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Możesz wybrać maksymalnie 3 tagi')));
      return;
    }
    setState(() {
      _isSubmiting = true;
    });
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('user_categories').doc(user.uid).set({
        'experience': CategoryExperienceHelper.getValue(_selectedCategoryExperience),
        'degree': CategoryDegreeHelper.getValue(_selectedCategoryDegree),
        'company size': CategoryCompanySizeHelper.getValue(_selectedCompanySize),
        'technologies': _selectedTechnology,
      });
      setState(() {
        _isSubmiting = false;
      });
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'active': true,
      });

      _selectedTechnology = [];
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Błąd autoryzacji.'),
      ));
      setState(() {
        _isSubmiting = false;
      });
    }
  }

  void _onSubmitEmployee() async {
    if (_selectedTechnology.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wybierz co najmniej 1 tag')));
      return;
    }
    if (_selectedTechnology.length > 3) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Możesz wybrać maksymalnie 3 tagi')));
      return;
    }
    setState(() {
      _isSubmiting = true;
    });
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('user_categories').doc(user.uid).set({
        'experience': CategoryExperienceHelper.getValue(_selectedCategoryExperience),
        'degree': CategoryDegreeHelper.getValue(_selectedCategoryDegree),
        'technologies': _selectedTechnology,
      });
      setState(() {
        _isSubmiting = false;
      });

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'active': true,
      });

      _selectedTechnology = [];
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Błąd autoryzacji.'),
      ));
      setState(() {
        _isSubmiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dostosuj swój profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stopień zaawansowania',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              value: _selectedCategoryExperience,
              icon: Icon(Icons.arrow_drop_down_circle_rounded, color: Theme.of(context).colorScheme.primary),
              items: CategoryExperience.values
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          '${category.name[0].toUpperCase()}${category.name.substring(1)}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ))
                  .toList(),
              onChanged: (selectedCategory) {
                if (selectedCategory == null) {
                  return;
                }
                setState(() {
                  _selectedCategoryExperience = selectedCategory; // set selected category
                });
              },
            ),
            const Text(
              'Wykształcenie',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              value: _selectedCategoryDegree,
              icon: Icon(Icons.arrow_drop_down_circle_rounded, color: Theme.of(context).colorScheme.primary),
              items: CategoryDegree.values
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          '${category.name[0].toUpperCase()}${category.name.substring(1)}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ))
                  .toList(),
              onChanged: (selectedCategory) {
                if (selectedCategory == null) {
                  return;
                }
                setState(() {
                  _selectedCategoryDegree = selectedCategory; // set selected category
                });
              },
            ),
            FutureBuilder(
              future: userRef.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                if (snapshot.hasError) return const Text('Coś poszło nie tak...');
                if (snapshot.data == null || snapshot.data?.data() == null) return const CircularProgressIndicator();
                if (snapshot.data!.data()!['role'] == UserRolesHelper.getValue(UserRoles.employer)) {
                  return Column(
                    children: [
                      const Text(
                        'Wielkośc firmy',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton(
                        value: _selectedCompanySize,
                        icon: Icon(Icons.arrow_drop_down_circle_rounded, color: Theme.of(context).colorScheme.primary),
                        items: CategoryCompanySize.values
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    '${category.name[0].toUpperCase()}${category.name.substring(1)}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ))
                            .toList(),
                        onChanged: (selectedCategory) {
                          if (selectedCategory == null) {
                            return;
                          }
                          setState(() {
                            _selectedCompanySize = selectedCategory; // set selected category
                          });
                        },
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
            const Text('Tagi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ChipsChoice<String>.multiple(
              value: _selectedTechnology,
              onChanged: (selectedTech) => setState(() {
                _selectedTechnology = selectedTech;
              }),
              choiceItems: C2Choice.listFrom<String, String>(
                source: _avaiableTechs,
                value: (i, v) => v,
                label: (i, v) => v,
              ),
            ),
            const Spacer(),
            !_isSubmiting
                ? Center(
                    child: FutureBuilder(
                      future: userRef.get(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null || snapshot.data?.data() == null) return const CircularProgressIndicator();
                        if (snapshot.data!.data()!['role'] == 'employer') return ElevatedButton.icon(icon: const Icon(Icons.save), onPressed: _onSubmitEmployer, label: const Text('Zapisz'));

                        return ElevatedButton.icon(icon: const Icon(Icons.save), onPressed: _onSubmitEmployee, label: const Text('Zapisz'));
                      },
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
