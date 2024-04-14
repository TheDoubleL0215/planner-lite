import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/model/Task.dart';
import 'package:planner_lite/pages/ClassTile.dart';
import 'package:planner_lite/pages/EditDetails.dart';
import 'package:planner_lite/pages/TaskClassTile.dart';
import 'package:intl/intl.dart';


class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());


  List months = ["január", "február", "március", "április", "május", "június", "július", "augusztus", "szeptember", "október", "november", "december"];

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Flexible(
          child: Container(
            child: Obx(() {
              print("Itt is vannak a taskok a megjelenítéshez: ${_classSubjectController.tasksList}");
              // Ellenőrizzük, hogy van-e olyan elem, ahol a haveHomework nem 0
              bool hasHomework = _classSubjectController.tasksList.isEmpty;

              // Ha nincs olyan elem, akkor megjelenítjük az üzenetet
              if (hasHomework) {
                return Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "lib/icons/NoMoreTask.svg",
                          width: 300,
                          height: 300,
                        ),
                        Text(
                          "Nincs több feladatod!",
                          style: TextStyle(
                            fontSize: 28,
                          ),
                            textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Ha vannak olyan elemek, ahol a haveHomework nem 0, akkor a listát jelenítjük meg
              return GroupedListView(
                groupBy: (element) => element.date,
                groupSeparatorBuilder: (value) => Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  width: double.maxFinite,
                  padding: EdgeInsets.all(16),
                  child: Text( (() {
                      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                      final tomorrow = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
                      if (value.toString() == tomorrow) {
                        return "Holnap";
                      } else if (value.toString() == today) {
                        return "Ma";
                      }else{
                        return months[int.parse(value.toString().substring(6, 7))-1] + " " + value.toString().substring(8) + ".";
                      }
                    })(),
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18),
                  ),
                ),
                elements: _classSubjectController.tasksList,
                itemBuilder: (context, element) {
                  return Dismissible(
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline_rounded),
                          Text("Törlés")
                        ],
                      ),
                    ),
                    direction: DismissDirection.none,
                    key: ValueKey(element),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        _classSubjectController.removeTask(element.id!);
                      });
                      _classSubjectController.tasksList.remove(element);
                    },
                    child: TaskClassTile(
                      subjectName: element.subject.toString(),
                      subjectIcon: element.subjectIcon.toString(),
                      examType: element.examType!,
                      taskId: element.id!,
                      date: element.date!,
                      type: element.type!,
                      subjectDecorator: element.subjectColor.toString().substring(6, element.subjectColor.toString().length - 1),
                      checked: element.completed!,
                      details: element.details!,
                    ),
                  );
                }
              );
            }),
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.notification_add_rounded, size: 30,),
      elevation: 0,
      onPressed: ()  {
        openNewEventDialog(context);
      },
    ),
  );
}

  Future<dynamic> openNewEventDialog(BuildContext context){
    TextEditingController _dateController = TextEditingController();
    TextEditingController _titleController = TextEditingController();
    String _titleText = '';

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

    bool _dateFieldValidator = false;
    bool _titleFieldValidator = false;


    return showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Új emlékeztető", style: TextStyle(fontSize: 32, ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                  width: 1,
                                )
                              ),
                              labelText: 'Emlékeztető',
                              filled: false,
                              errorText: _titleFieldValidator ? "Adj meg egy címet!" : null
                            ),
                            onTap: (){
                              setState((){
                                _titleFieldValidator = false;
                              });
                            },
                            onChanged: (value) {
                              setState((){
                                value.isNotEmpty ? _titleFieldValidator = false : null;
                              });
                            },
                            onSubmitted: (String value){
                              setState(() {
                                _titleText = _titleController.text;
                              });
                            },
                          ),
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
                              setState((){
                                _dateFieldValidator = false;
                              });
                            },
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
                                    if(_titleController.text.isNotEmpty && _dateController.text.isNotEmpty){
                                      _classSubjectController.addTask(
                                      task: Task(
                                        subject: _titleController.text,
                                        subjectColor: "Color(0xff2196f3)",
                                        subjectIcon: "noIcon",
                                        type: "Reminder",
                                        examType: "",
                                        date: _dateController.text,
                                        gotFromId: 1,
                                        completed: 0,
                                        details: ""
                                      )
                                    ),
                                    _classSubjectController.getClasses(),
                                    _classSubjectController.getTasks(),
                                    print("subject: ${_titleController.text} subjectColor: ${""},type: Reminder, examType: ${""} date: ${_dateController.text} gotFromId: ${0}"),
                                    Get.back(),
                                  }else{
                                    if(_titleController.text.isEmpty){
                                      setState((){
                                        _titleFieldValidator = true;
                                      })
                                    },
                                    if(_dateController.text.isEmpty){
                                      setState((){
                                        _dateFieldValidator = true;
                                      })
                                    }
                                  }
                                  
                                }, 
                                child: Text("Mentés")
                              )
                            ],
                          ),
                        ),
                    
                    ]),
                  ),
                ),
              ),
            );
          },
        );
      } 
    );
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }
}



