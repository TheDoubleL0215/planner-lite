import 'dart:convert';

import 'package:flutter/material.dart';

class Task{
  int? id;
  String? subject;
  String? subjectColor;
  String? type;
  String? date;
  String? examType;
  String? details;
  int? gotFromId;
  int? completed;
  
  Task({
    this.id,
    this.subject, 
    this.subjectColor,
    this.type,
    this.date,
    this.examType,
    this.details,
    this.gotFromId,
    this.completed,
  });

  Task.fromJson(Map<String, dynamic> json){
    id = json["id"];
    subject = json["subject"];
    subjectColor = json["subjectColor"];
    type = json["type"];
    date = json["date"];
    examType = json["examType"];
    details = json["details"];
    gotFromId = json["gotFromId"];
    completed = json["completed"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["subject"] = this.subject;
    data["subjectColor"] = this.subjectColor;
    data["type"] = this.type;
    data["date"] = this.date;
    data["examType"] = this.examType;
    data["details"] = this.details;
    data["gotFromId"] = this.gotFromId;
    data["completed"] = this.completed;

    return data;
  }

}