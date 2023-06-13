import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_match/modals/enums.dart';

class ContinueRegisterScreen extends StatefulWidget {
  const ContinueRegisterScreen({super.key});

  @override
  State<ContinueRegisterScreen> createState() => _ContinueRegisterScreenState();
}

CategoryExperience _selectedCategoryExperience = CategoryExperience.trainee; //default kategoria / kategoria wybrana wcześniej
CategoryDegree _selectedCategoryDegree = CategoryDegree.highScool;
CategoryCompanySize _selectedCompanySize = CategoryCompanySize.none;
// RangeValues _currentRangeValues = const RangeValues(18, 35);
List<String> _selectedTechnology = [];
List<String> _avaiableTechs = CategoryTechnologyHelper.getValues();
bool _isSubmiting = false;

class _ContinueRegisterScreenState extends State<ContinueRegisterScreen> {
  final user = FirebaseAuth.instance.currentUser!;

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
        'company_size': CategoryCompanySizeHelper.getValue(_selectedCompanySize),
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
        title: const Text('Uzupełnij swój profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stopień zaawansowania', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 15),
            const Text('Wykształcenie', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 15),
            // if pracodawca show this
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text('Wiek pracownika', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            //       const SizedBox(height: 10),
            //       Text('${_currentRangeValues.start.round()}-${_currentRangeValues.end.round()}', style: const TextStyle(fontSize: 18)),
            //       RangeSlider(
            //         values: _currentRangeValues,
            //         min: 18,
            //         max: 50,
            //         onChanged: (RangeValues values) {
            //           setState(() {
            //             _currentRangeValues = values;
            //           });
            //         },
            //       ),
            //     ],
            //   ),

            // const SizedBox(height: 15),

            FutureBuilder(
              future: userRef.get(),
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data?.data() == null) return const CircularProgressIndicator();
                if (snapshot.data!.data()!['role'] == 'employer') {
                  return Column(
                    children: [
                      const Text('Wielkośc firmy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 15),
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
                        if (snapshot.data!.data()!['role'] == 'employer') return ElevatedButton(onPressed: _onSubmitEmployer, child: const Text('Dokoncz rejestracje'));

                        return ElevatedButton(onPressed: _onSubmitEmployee, child: const Text('Dokoncz rejestracje'));
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
