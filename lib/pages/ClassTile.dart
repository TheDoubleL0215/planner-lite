

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/model/Task.dart';
import 'package:planner_lite/pages/CreateClass.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassTile extends StatefulWidget {
  const ClassTile({super.key, required this.classId, required this.subjectName, required this.classPeriod, required this.subjectDecorator, required this.dayId, required this.haveHomework, required this.subjectIcon});

  final String subjectName;
  final String subjectDecorator;
  final String subjectIcon;
  final int classPeriod;
  final int classId;
  final int dayId;
  final String haveHomework;

  static const TextStyle ClassNameFontStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  @override
  State<ClassTile> createState() => _ClassTileState();
}

class _ClassTileState extends State<ClassTile> {


  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());


    TextEditingController _dateController = TextEditingController();

    List<String> classHoursList = ["7:45 - 8:30", "8:40 - 9:25", "9:40 - 10:25", "10:35 - 11:20", "11:30 - 12:15", "12:25 - 13:10", "13:15 - 14:00", "14:00 - 14:45"];

    Future<void> _selectDate() async{
      DateTime? _picked = await showDatePicker(
        context: context, 
        initialDate: DateTime.now(),
        firstDate: DateTime(2000), 
        lastDate: DateTime(3000)
      );
      if(_picked != null){
        setState((){
          _dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }

    Set _selectedExamType = {"ropdolgozat"};



    void addToTasks(){

    }


    void handleActionInsideModal(String value) {
    switch (value) {
      case 'Szerkesztés':

        break;
      case 'Törlés':
        Get.back();
        _classSubjectController.delete(widget.classId);
        _classSubjectController.getClasses();
        break;
      }
    }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          showClassModal(context);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          // ignore: sort_child_properties_last
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 0),
                child: Text(widget.classPeriod.toString(),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 70,
                width: 4,
                child: DecoratedBox(
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color(int.parse(widget.subjectDecorator))
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "lib/icons/${widget.subjectIcon}.svg",
                        height: 32,
                        width: 32,
                      ),
                    ),
                            
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(widget.subjectName,
                      style: ClassTile.ClassNameFontStyle,
                      textAlign: TextAlign.center,),
                  ),
                ],
              ),
              Spacer(),
              widget.haveHomework == '1' ?
              SvgPicture.asset(
                    "lib/icons/homework_icon.svg",
                    height: 32,
                    width: 32,
              ):Container(),
                  
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Color.fromRGBO(58, 58, 58, 1)
          ),
        ),
      ),
    );
  }



Future<dynamic> showExamDialog(BuildContext context){

  TextEditingController _dateController = TextEditingController();

    Future<void> _selectDate() async{
      DateTime? _picked = await showDatePicker(
        context: context, 
        initialDate: DateTime.now(),
        firstDate: DateTime(2000), 
        lastDate: DateTime(3000)
      );
      if(_picked != null){
        setState((){
          _dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }

  Set _selectedExamType = {"ropdolgozat"};

  bool _dateFieldValidator = false;


  return showDialog(
    context: context, 
    builder: (context){
    return  StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Új számonkérés", style: TextStyle(fontSize: 32, ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        style: BorderStyle.solid,
                        width: 1,
                      )
                    ),
                    prefixIcon: Icon(Icons.calendar_today),
                    labelText: 'Dátum',
                    filled: false,
                    errorText: _dateFieldValidator ? "Adj meg egy dátumot!" : null
                  ),
                  readOnly: true,
                  onTap: (){
                    _selectDate();
                  },
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: double.maxFinite,
                  child: SegmentedButton(
                    showSelectedIcon: false,
                  segments: <ButtonSegment>[
                    ButtonSegment(
                        value: "ropdolgozat",
                        //icon: SvgPicture.asset("lib/icons/ExamIcon.svg", height: 26, width: 26),
                        label: Text("Röpdoga", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(),)
                        ),
                    ButtonSegment(
                        value: "feleles",
                        //icon: SvgPicture.asset("lib/icons/feleles_icon.svg", height: 26, width: 26),
                        label: Text("Felelés"),
                    ),
                    ButtonSegment(
                        value: "temazaro",
                        //icon: SvgPicture.asset("lib/icons/temazaro_icon.svg", height: 26, width: 26),
                        label: Text("Témazáró", style: TextStyle(overflow: TextOverflow.fade),),
                        ),
                  ],
                  selected: _selectedExamType,
                  style: ButtonStyle(visualDensity: VisualDensity(horizontal: -4)),
                  onSelectionChanged: (Set newSelection){
                    setState(() {
                      _selectedExamType = newSelection;
                    });
                  }
                              ),
                ),
              ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => {
                        Get.back()
                      },
                      child: Text("Mégse"),
                    ),
                    FilledButton(
                      onPressed: () => {
                        setState(() {
                         _dateController.text.isEmpty ? _dateFieldValidator = true : _dateFieldValidator = false;
                        }),
                        if(_dateController.text.isNotEmpty){
                          _classSubjectController.addTask(
                            task: Task(
                              subject: widget.subjectName,
                              subjectColor: widget.subjectDecorator,
                              subjectIcon: widget.subjectIcon,
                              type: "Exam",
                              examType: _selectedExamType.first,
                              date: _dateController.text,
                              gotFromId: widget.classId,
                              completed: 0,
                              details: ''
                            )
                          ),
                          _classSubjectController.getClasses(),
                          _classSubjectController.getTasks(),
                          Get.back(),
                          print("subject: ${widget.subjectName} subjectColor: ${widget.subjectDecorator},type: Exam, examType: ${_selectedExamType.first} date: ${_dateController.text} gotFromId: ${widget.classId}")
                        }
                      }, 
                      child: Text("Mentés")
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );;
        },
      );
    }
  );


}

Future<dynamic> showClassModal(BuildContext context) {

  bool localHaveHomework = widget.haveHomework == '1' ? true : false;
  

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
      return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              height: 6,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[600]
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 0),
                child: Text(widget.classPeriod.toString(),
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 70,
                width: 4,
                child: DecoratedBox(
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color(int.parse(widget.subjectDecorator))
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "lib/icons/${widget.subjectIcon}.svg",
                    height: 32,
                    width: 32,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Align(
                  child: Text(widget.subjectName,
                    style: ClassTile.ClassNameFontStyle,
                    textAlign: TextAlign.center,),
                ),
              ),
              Spacer(),
              PopupMenuButton<String>(
                onSelected: handleActionInsideModal,
                itemBuilder: (BuildContext context) {
                  return {'Törlés'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: choice=='Szerkesztés' ? Icon(Icons.edit) : Icon(Icons.delete),
                        ),
                        Text(
                          choice,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    );
                  }).toList();
                },
              ),
        
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule_rounded),
              SizedBox(width: 8,),
              Text(classHoursList[widget.classPeriod - 1]),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(58, 58, 58, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(5), topRight: Radius.circular(5))
                    )
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if(localHaveHomework == false){
                      if(prefs.getBool("advancedHomework") ?? false){
                        showDescDialog(context);
                      }else{
                        HapticFeedback.vibrate();
                        _classSubjectController.addHomework(widget.classId, "");
                        setState(() {
                          localHaveHomework = !localHaveHomework;
                        });
                      }
                      
                    }else{
                      HapticFeedback.vibrate();
                      _classSubjectController.addHomework(widget.classId, "");
                      setState(() {
                        localHaveHomework = !localHaveHomework;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ 
                        !localHaveHomework
                          ? SvgPicture.asset(
                              "lib/icons/homework_icon.svg",
                              key: ValueKey("HomeworkIcon"),
                              height: 32,
                              width: 32,
                            )
                          : SvgPicture.asset(
                              "lib/icons/HomeworkTick.svg",
                              key: ValueKey("HomeworkTick"),
                              height: 32,
                              width: 32,
                            ),
                        SizedBox(height: 8),
                        Text('Házi feladat', style: TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(58, 58, 58, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(15), topRight: Radius.circular(15))
                    )
                  ),
                  onPressed: () => showExamDialog(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "lib/icons/ExamIcon.svg",
                          height: 32,
                          width: 32,
                        ),
                        SizedBox(height: 8),
                        Text('Dolgozat', style: TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

    );
      });
  });
  }
  
  Future<dynamic> showDescDialog(BuildContext context){

  TextEditingController _descController = TextEditingController();

  bool _dateFieldValidator = false;

  return showDialog(
    context: context, 
    builder: (context){
    return  StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Leírás hozzáadása", style: TextStyle(fontSize: 32, ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _descController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        style: BorderStyle.solid,
                        width: 1,
                      )
                    ),
                    prefixIcon: Icon(Icons.notes),
                    labelText: 'Leírás',
                    filled: false,
                  ),
                ),
              ),
              
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => {
                        Get.back()
                      },
                      child: Text("Mégse"),
                    ),
                    FilledButton(
                      onPressed: () => {
                        HapticFeedback.vibrate(),
                        _classSubjectController.addHomework(widget.classId, _descController.text),
                        Get.back(),
                        Get.back()
                      }, 
                      child: Text("Mentés"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );;
        },
      );
    }
  );


}
}

