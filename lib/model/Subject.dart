import 'dart:convert';

import 'package:flutter/material.dart';

class Subject{
  int? id;
  String? subject;
  String? subjectColor;
  String? teacherName;
  String? subjectIcon;
  
  Subject({
    this.id,
    this.subject, 
    this.subjectColor,
    this.teacherName,
    this.subjectIcon
  });

  Subject.fromJson(Map<String, dynamic> json){
    id = json["id"];
    subject = json["subject"];
    subjectColor = json["subjectColor"];
    teacherName = json["teacherName"];
    subjectIcon =json["subjectIcon"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["subject"] = this.subject;
    data["subjectColor"] = this.subjectColor;
    data["teacherName"] = this.teacherName;
    data["subjectIcon"] = this.subjectIcon;

    return data;
  }

}