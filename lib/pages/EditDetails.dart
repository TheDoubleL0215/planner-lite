import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/model/Task.dart';

class EditDetails extends StatefulWidget {
  const EditDetails({super.key, required this.subjectName, required this.subjectDecorator, required this.taskId, required this.date, required this.type, required this.examType, required this.checked, required this.details});

  final String subjectName;
  final String subjectDecorator;
  final int taskId;
  final String date;
  final String type;
  final String examType;
  final int checked;
  final String details;

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

  class _EditDetailsState extends State<EditDetails> {

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


    TextEditingController _titleController = TextEditingController();
    TextEditingController _detailsController = TextEditingController();
    TextEditingController _dateController = TextEditingController();

    final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());

    Set _selectedExamType = {""};

    @override
    void initState() {
      super.initState();
      _titleController.text = "${widget.subjectName}${widget.type != "Reminder" ? " - " : ""}${widget.type != "Reminder" ? getTypeText(widget.type, widget.examType) : ""}";
      _detailsController.text = widget.details;
      _dateController.text = widget.date;
      _selectedExamType = {widget.examType};
    }

    void handleActionInsideModal(String value) {
      switch (value) {
        case 'Törlés':
         _classSubjectController.removeTask(widget.taskId);
          Get.back();
          break;
      }
    }

    Future<void> _selectDate() async{
      DateTime? _picked = await showDatePicker(
        context: context, 
        initialDate: DateTime.parse(widget.date),
        firstDate: DateTime(2000), 
        lastDate: DateTime(3000)
      );
      if(_picked != null){
        setState((){
          _dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }


  @override
  Widget build(BuildContext context) {



    return PopScope(
      onPopInvoked: (didPop) async {
      if (didPop) {
        print("Ezek a részletek: ${widget.details}");
      }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FilledButton(
                onPressed: () async {
                  /*_classSubjectController.removeTask(widget.taskId);
                  await _classSubjectController.addTask(
                    task: Task(
                      subject: widget.type == "Reminder" ? _titleController.text.toString() : widget.subjectName,
                      subjectColor: "Color(${widget.subjectDecorator.toString()})",
                      type: widget.type.toString(),
                      examType: widget.examType.toString(),
                      gotFromId: 0,
                      completed: widget.checked,
                      date: _dateController.text.toString(),
                      details: _detailsController.text.toString()
                    )
                    
                  );*/
                  _classSubjectController.updateTask(
                    task: Task(
                      id: widget.taskId,
                      subject: widget.type == "Reminder" ? _titleController.text.toString() : widget.subjectName,
                      subjectColor: "Color(${widget.subjectDecorator.toString()})",
                      type: widget.type.toString(),
                      examType: widget.type == "Exam" ? _selectedExamType.first : widget.examType.toString(),
                      gotFromId: 0,
                      completed: widget.checked,
                      date: _dateController.text.toString(),
                      details: _detailsController.text.toString(),
                    ),
                    taskId: widget.taskId
                  );
                  Get.back();
                }, 
                child: Text("Mentés")
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  readOnly: widget.type != "Reminder" ? true : false,
                  style: TextStyle(
                    fontSize: 32
                  ),
                  decoration: InputDecoration(
                    hintText: "Nincs cím",
                    border: InputBorder.none
                  ),
                  controller: _titleController,
                  onChanged: (value) {
                
                  },
                ),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _detailsController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.notes),
                  hintText: "Részletek megadása",
                  border: InputBorder.none
                ),
                onChanged: (value) {
              
                },
              ),
              widget.type == "Exam" ? Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
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
                    print(_selectedExamType);
                  }
                              ),
                ),
              ):Container(),
              TextField(
                onTap: (){
                  _selectDate();
                },
                readOnly: true,
                controller: _dateController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: "Dátum",
                  border: InputBorder.none
                ),
                onChanged: (value) {
              
                },
              ),
          ],),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                onPressed: (){
                  _classSubjectController.removeTask(widget.taskId);
                  Get.back();
                }, 
                icon: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.primary,)),
              Spacer(),
              TextButton(
                onPressed: (){
                  _classSubjectController.checkTask(widget.taskId);
                  Get.back();
                },
                child: Text(widget.checked == 0 ? "Feladat kész!" : "Feladat befejezetlen", style: TextStyle(fontSize: 16),)
              ),
            ],
          ),
        )
      ),
    );
  }
}