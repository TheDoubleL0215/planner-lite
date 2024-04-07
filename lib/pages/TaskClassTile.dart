import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/pages/CreateClass.dart';
import 'package:get/get.dart';
import 'package:planner_lite/pages/EditDetails.dart';

import 'Preferences.dart';

class TaskClassTile extends StatefulWidget {
  const TaskClassTile({super.key, required this.taskId, required this.subjectName, required this.subjectDecorator, required this.date, required this.type, required this.examType, required this.checked, required this.details});

  final String subjectName;
  final String subjectDecorator;
  final int taskId;
  final String date;
  final String type;
  final String examType;
  final int checked;
  final String details;

  static const TextStyle ClassNameFontStyle =
    TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

  @override
  State<TaskClassTile> createState() => _ClassTileState();
}

class _ClassTileState extends State<TaskClassTile> {

  bool? isChecked;
  
  void initState() {
    super.initState();
    // Az adatbázisból kapott érték alapján állítsuk be a checkbox állapotát
    isChecked = widget.checked == 0 ? false : true;
  }

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());

  String getTypeText(String type, String examType) {
  if (type == "homework") {
    return "Házi feladat";
  } else if (type == "Exam") {
    if (examType == "feleles") {
      return "Felelés";
    } else if (examType == "ropdolgozat") {
      return "Röpdolgozat";
    } else if (examType == "temazaro") {
      return "Témazáró";
    }
  } else if(type == "Reminder"){
    return "Emlékeztető";
  }
  // Alapértelmezett eset, ha nincs illeszkedő feltétel
  return "";
  }

  String getTypeIcon(String type, String examType) {
  if (type == "homework") {
    return "homework";
  } else if (type == "Exam") {
    if (examType == "feleles") {
      return "feleles";
    } else if (examType == "ropdolgozat") {
      return "ropdolgozat";
    } else if (examType == "temazaro") {
      return "temazaro";
    }
  } else if(type == "Reminder"){
    return "emlekezteto";
  }
  // Alapértelmezett eset, ha nincs illeszkedő feltétel
  return "";
  }

  String getSubjectIcon(String type) {
    if(type == "Reminder"){
      return "";
    }
    return widget.subjectName.toLowerCase();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0, bottom: 8, top: 8, right: 8),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked, 
                      onChanged: (newValue){
                        setState(() {
                          isChecked = newValue!;
                        });
                        _classSubjectController.checkTask(widget.taskId);
                        isChecked! ? print("Kicsekkolva") : 0;
                      }),
                    Padding(
                      padding: EdgeInsets.all(widget.type == "Reminder" ? 0.0 : 3.0),
                      child: widget.type != "Reminder" ? Container(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "lib/icons/${getSubjectIcon(widget.type)}.svg",
                          height: 36,
                          width: 36,
                        ),
                      ):null
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  widget.subjectName,
                                  style: TextStyle(fontSize: widget.type == "Reminder" ? 20 : 24,  decoration: isChecked == true ? TextDecoration.lineThrough : null, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            "lib/icons/${getTypeIcon(widget.type, widget.examType)}_icon.svg",
                            height: 36*0.618,
                            width: 36*0.618,
                          ),
                        ),
                
                        Text(getTypeText(widget.type, widget.examType), style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 12),),
                      ],
                    ), // A jobb oldali igazításhoz
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }



}