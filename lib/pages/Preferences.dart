import 'package:flutter/material.dart';


const List<String> subjects = <String>["Irodalom", "Nyelvtan", "Matematika", "Történelem", "Hittan", "Biológia", "Fizika", "Földrajz", "Kémia", "Német", "Angol", "Ének", "Rajz", "Informatika", "Testnevelés"]; // Ne inicializáld itt


class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Beállítások",
          style: TextStyle(fontSize: 30)
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            ...FullDaySubjects("Hétfő"),
            ...FullDaySubjects("Kedd"),
            ...FullDaySubjects("Szerda"),
            ...FullDaySubjects("Csütörtök"),
            ...FullDaySubjects("Péntek"),

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {},
          child: const Center(
            child: Text('Mentés'),
          ),
        ),
      ),
    );

  }

  List<Widget> FullDaySubjects(String dayName) {
    return List.generate(
          8,
          (index) {
            if (index == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(dayName, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  HourSubject(classHour: index + 1),
                ],
              );
            } else {
              return HourSubject(classHour: index + 1);
            }
          },
        );
  }
}

class HourSubject extends StatefulWidget {
  const HourSubject({super.key, required this.classHour});

  final int classHour;

  @override
  State<HourSubject> createState() => _HourSubjectState();
}

class _HourSubjectState extends State<HourSubject> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('${widget.classHour}. óra', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
        const Expanded(child: SubjectDropdown()),
      ],
    );;
  }
}



class SubjectDropdown extends StatefulWidget {
  const SubjectDropdown({super.key});

  @override
  State<SubjectDropdown> createState() => _SubjectDropdownState();
}

class _SubjectDropdownState extends State<SubjectDropdown> {

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.0, // Állítsd be a kívánt keretvastagságot
          ),
          borderRadius: BorderRadius.circular(4.0), // Állítsd be a kívánt sarokrafordítást
        ),
        child: DropdownButton<String>(
            hint: const Text(
              "Tantárgy",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.end,
            ),
            value: selectedValue,
            onChanged: (newValue) => setState(() {selectedValue = newValue!;} ),
            items: subjects.map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              )
            ).toList(),

        ),
      );
  }
}