import 'package:flutter/material.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/model/ClassSubject.dart';
import 'package:planner_lite/pages/DayPages/DayLoader.dart';
import 'package:planner_lite/pages/timetable.dart';
import 'package:get/get.dart';

const List<String> subjects = <String>["Irodalom", "Nyelvtan", "Matek", "Történelem", "Hittan", "Biológia", "Fizika", "Földrajz", "Kémia", "Német", "Angol", "Ének", "Rajz", "Informatika", "Testnevelés", "Ofői"]; // Ne inicializáld itt
const List<Color> subjectColors = <Color>[
Color.fromRGBO(244, 67, 54,1.0),
Color.fromRGBO(233, 30, 99,1.0),
Color.fromRGBO(156, 39, 176,1.0),
Color.fromRGBO(103, 58, 183,1.0),
Color.fromRGBO(63, 81, 181,1.0),
Color.fromRGBO(33, 150, 243,1.0),
Color.fromRGBO(3, 169, 244,1.0),
Color.fromRGBO(0, 188, 212,1.0),
Color.fromRGBO(0, 150, 136,1.0),
Color.fromRGBO(76, 175, 80,1.0),
Color.fromRGBO(139, 195, 74,1.0),
Color.fromRGBO(255, 235, 59,1.0),
Color.fromRGBO(255, 193, 7,1.0),
Color.fromRGBO(255, 87, 34,1.0),
];
const List<String> daysList = <String>["Hétfő", "Kedd", "Szerda", "Csütörtök", "Péntek"];
const List<int> classHours = <int>[1, 2, 3, 4, 5, 6, 7, 8];


class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());

  String? _selectedSubjectValue;
  String? _selectedDayValue;
  String? _selectedHourValue;
  int _selectedColor = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Új tanóra",
          style: TextStyle(fontSize: 30)),),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Row(
            children: [
              Text("Tanóra", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
              Spacer(),
              SizedBox(
                width: 200,
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedSubjectValue,
                  hint: Text("Tantárgy"),
                  items: subjects.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _selectedSubjectValue = value!;
                  });
                }),
              )
            ],
          ),
          Row(
            children: [
              Text("Idő", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  value: _selectedDayValue,
                  hint: Text("Nap"),
                  items: daysList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _selectedDayValue = value!;
                  });
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  value: _selectedHourValue,
                  hint: Text("Óra"),
                  items: classHours.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text("${value.toString()}. óra"),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                  setState(() {
                    _selectedHourValue = value!;
                  });
                }),
              )
            ],
          ),
          SizedBox(height: 20,),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  const Row(
                    children: [
                      Text("Szín", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      Spacer(),
                    ],
                  ),
                Wrap(
                  children: List.generate(
                    subjectColors.length, 
                    (int index){
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            _selectedColor = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: _selectedColor==index? BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                            ):BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.transparent,
                                width: 4.0,
                            )),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: subjectColors[index],
                            ),
                          ),
                        ),
                      );
                    }),
                )
                ],
              ),
            ],
          ),
        ],
        

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: FilledButton.tonal(
          onPressed: () async {
          if (_selectedSubjectValue != null && _selectedDayValue != null && _selectedHourValue != null) {
            _addClassToDb();
          }else{
            Get.snackbar(
              "Hiba",
              "Nem minden mező van kitöltve!",
              colorText: Colors.white,
              backgroundColor: Colors.black26,
              icon: const Icon(Icons.warning_rounded),
            );
            print("Valami nincs kitöltve!");
          }
          },
          child: const Center(
            child: Text('Hozzáadás'),
          ),
        ),
      ),
    );
  }


  /*              await SubjectsDB.create(subject: _selectedSubjectValue ?? '', day: _selectedDayValue ?? '', hour: int.parse(_selectedHourValue ?? '0'), subjectColor: subjectColors[_selectedColor].toString(), );
              print("$_selectedSubjectValue $_selectedDayValue, $_selectedHourValue, ${subjectColors[_selectedColor]}");
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context, "refresh");
  */

  _addClassToDb() async{
    print("NormalIndex ${_selectedDayValue ?? ''}");
    print("Indexe a napnak ${daysList.indexOf(_selectedDayValue ?? '')}");
    _classSubjectController.addClass(
      classSubject:ClassSubject(
        subject: _selectedSubjectValue ?? '',
        day: daysList.indexOf(_selectedDayValue ?? ''),
        hour: int.parse(_selectedHourValue ?? '0'),
        subjectColor: subjectColors[_selectedColor].toString(),
        haveHomework: "0"
      )
    );
    Get.back();
  }


}

