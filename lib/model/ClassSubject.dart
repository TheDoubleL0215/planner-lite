import 'dart:convert';

import 'package:flutter/material.dart';

class ClassSubject{
  int? id;
  int? day;
  int? hour;
  String? subject;
  String? subjectColor;
  String? haveHomework;
  
  ClassSubject({
    this.id,
    this.day,
    this.hour,
    this.subject, 
    this.subjectColor,
    this.haveHomework
  });

  ClassSubject.fromJson(Map<String, dynamic> json){
    id = json["id"];
    day = json["day"];
    hour = json["hour"];
    subject = json["subject"];
    subjectColor = json["subjectColor"];
    haveHomework = json["haveHomework"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["day"] = this.day;
    data["hour"] = this.hour;
    data["subject"] = this.subject;
    data["subjectColor"] = this.subjectColor;
    data["haveHomework"] = this.haveHomework;

    return data;
  }

}