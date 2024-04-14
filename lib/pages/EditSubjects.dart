import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';


class EditSubject extends StatefulWidget {
  const EditSubject({super.key});

  @override
  State<EditSubject> createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Tantárgyak szerkesztése"),
      ),
      body:
      SingleChildScrollView(
        child:  Obx(() =>
          Wrap(
            children: List.generate(
              _classSubjectController.subjectsList.length, 
              (int index){
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child:subjectTile(subjectName: _classSubjectController.subjectsList[index].subject!, subjectIcon: _classSubjectController.subjectsList[index].subjectIcon!, subjectColor: _classSubjectController.subjectsList[index].subjectColor!, subjectId: _classSubjectController.subjectsList[index].id!,)
                );
              }),
          ),
        ),
      )
          
          
    );
  }
}

class subjectTile extends StatelessWidget {
  subjectTile({
    super.key, required this.subjectName, required this.subjectIcon, required this.subjectColor, required this.subjectId,
  });

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());

  final int subjectId;
  final String subjectName;
  final String subjectIcon;
  final String subjectColor;

  void handleActionInsideModal(String value) {
    switch (value) {
      case 'Szerkesztés':

        break;
      case 'Törlés':
        _classSubjectController.deleteSubject(subjectId);
        _classSubjectController.getSubjects();
        break;
      }
    }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(maxRadius: 10, backgroundColor: Color(int.parse(subjectColor.substring(6, subjectColor.toString().length-1)))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset("lib/icons/${subjectIcon}.svg"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, left: 12),
            child: Text(subjectName),
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
                    child: Icon(Icons.delete),
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
      
    );
  }
}
