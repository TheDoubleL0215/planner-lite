import 'package:flutter/cupertino.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/model/ClassSubject.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService{
  Database? _database;

  Future<Database> get database async{
    if (_database != null){
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async{
    const name = "classes.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async{
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true
    );
    return database;
  }

  Future<void> create(Database database, int version) async {
    print('creating the database...');
    await SubjectsDB().createTable(database);
  }

  Future<void> deleteDatabase(String path) =>
    databaseFactory.deleteDatabase(path);
}