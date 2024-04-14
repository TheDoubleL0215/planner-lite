import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/pages/ClassTile.dart';
import 'package:planner_lite/pages/CreateClass.dart';
import 'package:get/get.dart';


class DayLoader extends StatefulWidget {
  const DayLoader({super.key, required this.loadDayValue});

  final int loadDayValue;


  @override
  State<DayLoader> createState() => _DayLoaderState();

}


class _DayLoaderState extends State<DayLoader> {

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx((){
            print("EZ lenne a cuccos: ${widget.loadDayValue}");
            _classSubjectController.currentDayPageSelected.value = widget.loadDayValue;
            print("From obx ${_classSubjectController.classesList}");
            bool hasTodayClass = !_classSubjectController.classesList.any((element) => element.day == widget.loadDayValue);
            if(hasTodayClass){
              print("Meg kellene jelennie");
              return SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "lib/icons/LearningBro.svg",
                          width: 300,
                          height: 300,
                        ),
                        Text("Itt még nincs óra.",
                        style: TextStyle(fontSize: 32, color: Theme.of(context).colorScheme.primary),
                        ),
                        const Text(
                          'Adj hozzá a jobb felső sarokban található "+" gombbal!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32*0.618
                            ),
                          ),

                      ],
                    ),
                  ))
                );
            }
            return ListView.builder(
              itemCount: _classSubjectController.classesList.length,
              itemBuilder: (_, index){
                  if(_classSubjectController.classesList[index].day == widget.loadDayValue){
                    return ClassTile(
                      subjectName: _classSubjectController.classesList[index].subject.toString(), 
                      subjectIcon: _classSubjectController.classesList[index].subjectIcon.toString(),
                      classPeriod: _classSubjectController.classesList[index].hour!, 
                      classId: _classSubjectController.classesList[index].id!,
                      dayId: _classSubjectController.classesList[index].day!,
                      haveHomework: _classSubjectController.classesList[index].haveHomework!,
                      subjectDecorator: _classSubjectController.classesList[index].subjectColor.toString().substring(6, _classSubjectController.classesList[index].subjectColor.toString().length-1));
                  }else{
                    return SizedBox();
                  }
                }
            );
          })
        ),
      ],
    );
  }
  
}
