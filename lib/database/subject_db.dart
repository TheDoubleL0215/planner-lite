import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/database/database_service.dart';
import 'package:planner_lite/model/ClassSubject.dart';
import 'package:planner_lite/model/Task.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class SubjectsDB {
  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());

  static final String tableName = 'subjects';
  static final String taskTableName = 'tasks';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" INTEGER NOT NULL,
      "day" INTEGER NOT NULL,
      "hour" INTEGER NOT NULL,
      "subject" TEXT NOT NULL,
      "subjectColor" TEXT NOT NULL,
      "haveHomework" TEXT NOT NULL,
      PRIMARY KEY ("id" AUTOINCREMENT)
    )""");
    await database.execute("""CREATE TABLE IF NOT EXISTS $taskTableName (
      "id" INTEGER NOT NULL,
      "subject" TEXT NOT NULL,
      "subjectColor" TEXT NOT NULL,
      "type" TEXT NOT NULL,
      "date" TEXT NOT NULL,
      "examType" TEXT,
      "details" TEXT,
      "gotFromId" INTEGER NOT NULL,
      "completed" INTEGER NOT NULL,
      PRIMARY KEY ("id" AUTOINCREMENT)
    )""");
  }

  static Future<int> insert(ClassSubject? classSubject) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, classSubject!.toJson()) ?? 1;
  }

  static Future<int> insertTask(Task? task) async {
    final database = await DatabaseService().database;
    return await database.insert(taskTableName, task!.toJson()) ?? 1;
  }

  static Future<int> updateTask(Task? task, int taskId) async {
    final database = await DatabaseService().database;
    return await database.update(taskTableName, task!.toJson(), where: 'id=?', whereArgs: [taskId]) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    final database = await DatabaseService().database;
    return await database.query(tableName, orderBy: 'hour');
  }

  static Future<List<Map<String, dynamic>>> queryTasks() async {
    final database = await DatabaseService().database;
    return await database.query(taskTableName);
  }

  static Future<void> toggleHomeworkFlag(int id, String dating) async {
    final database = await DatabaseService().database;

    final List<Map<String, dynamic>> currentValues =
        await database.rawQuery('SELECT haveHomework FROM $tableName WHERE id = ?', [id]);

    final String currentHomeworkValue = currentValues[0]['haveHomework'];

    final String newValue = currentHomeworkValue == "0" ? dating : "0";

    await database.rawUpdate('UPDATE $tableName SET haveHomework = ? WHERE id = ?', [newValue, id]);
  }

  static authClass(int classId) async {
    final database = await DatabaseService().database;
    return await database.rawQuery("SELECT * FROM $tableName WHERE id = $classId");
  }

  static Future<void> checkTask(int taskId) async {
    final database = await DatabaseService().database;
    var res = await database.rawQuery("SELECT * FROM $taskTableName WHERE id = $taskId");
    if (res.isNotEmpty && res[0]["completed"] == 0) {
      await database.update(taskTableName, {"completed" : 1}, where: 'id = ?', whereArgs: [taskId]);
    }else if(res.isNotEmpty && res[0]["completed"] == 1){
      await database.update(taskTableName, {"completed" : 0}, where: 'id = ?', whereArgs: [taskId]);
    }
  }

  static authTask(int classId) async {
    final database = await DatabaseService().database;
    return await database.rawQuery("SELECT * FROM $tableName WHERE gotFromId = $classId");
  }

  static delete(int classId) async {
    final database = await DatabaseService().database;
    return await database.delete(tableName, where: 'id=?', whereArgs: [classId]);
  }

  static removeTask(int taskId) async {
    final database = await DatabaseService().database;
    var prevHwValue = await database.rawQuery('SELECT * FROM $taskTableName WHERE id = ?', [taskId]);
    await database.update(tableName, {"haveHomework": '0'}, where: 'id = ?', whereArgs: [prevHwValue.first['gotFromId']]);
    print("Sikeres törlés");
    return await database.delete(taskTableName, where: 'id=?', whereArgs: [taskId]);
  }

  static addHomeworkWithDate(int id) async {
    final database = await DatabaseService().database;
    var dayTester = await database.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);

    if (dayTester.isNotEmpty) {
      final int idk = dayTester[0]["day"] as int;
      print("Weekday ${idk}");

      // Ha a modifier igaz, akkor a következő héten az adott nap lesz a nap
      DateTime nextWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1 - 7));
      print("Ez az nap!! $nextWeekDay");
      // Ha a modifier hamis, akkor csak a mai nap lesz a nap
      print("Ez az nap!! ${DateTime.now().subtract(Duration(days: DateTime.now().weekday - idk))}");
    } else {
      print("Nincs találat a lekérdezésre!");
    }
  }

  static Future<void> addHomework(int classId) async {
    final database = await DatabaseService().database;

    print("DayID: ${classId}");

    var reqOriginSubject = await database.rawQuery("SELECT * FROM $tableName WHERE id = $classId");
    print("Ennek ez az értéke: ${reqOriginSubject.first['haveHomework']}");

    if(reqOriginSubject.first['haveHomework'] == '0'){
      await database.update(tableName, {"haveHomework": '1'}, where: 'id = ?', whereArgs: [classId]);

      // origin datas
      String originSubjectName = reqOriginSubject.first['subject'].toString();
      String originDayId = reqOriginSubject.first['day'].toString();

      print("Ez a targerSubjectName: $originSubjectName $originDayId");

      //first request (this week)
      var target = await database.rawQuery("SELECT * FROM $tableName WHERE day > $originDayId AND subject = '$originSubjectName' ORDER BY day ASC LIMIT 1");

      //no more class this week
        if (target.isEmpty) {
          //second request (next week)
          target = await database.rawQuery("SELECT * FROM $tableName WHERE subject = '$originSubjectName' ORDER BY day ASC LIMIT 1");

          String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - (target[0]["day"] as int) - 1 - 7)));

          //task data package
          var newHomeworkTask = Task(
            subject: target.first["subject"].toString(),
            subjectColor: target.first["subjectColor"].toString(),
            type: "homework",
            date: formattedDate,
            examType: '',
            gotFromId: classId,
            completed: 0,
            details: ''
          );

          await database.insert(taskTableName, newHomeworkTask.toJson());

          print("Ez az nap (next week): $formattedDate");
        } else if (target.isNotEmpty) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - (target[0]["day"] as int) - 1)));

          //task data package
          var newHomeworkTask = Task(
            subject: target.first["subject"].toString(),
            subjectColor: target.first["subjectColor"].toString(),
            type: "homework",
            date: formattedDate,
            examType: '',
            gotFromId: classId,
            completed: 0,
            details: ''
          );

          await database.insert(taskTableName, newHomeworkTask.toJson());

          print("Ez az nap (this week): $formattedDate");
        }
    }else{
        print("MEgy az else ág!");
        var selectLastOne = await database.rawQuery('SELECT * FROM $taskTableName WHERE gotFromId = ?', [classId]);
        int taskId = int.parse(selectLastOne.first['id'].toString());
        var prevHwValue = await database.rawQuery('SELECT * FROM $taskTableName WHERE id = ?', [taskId]);
        await database.update(tableName, {"haveHomework": '0'}, where: 'id = ?', whereArgs: [prevHwValue.first['gotFromId']]);
        await database.delete(taskTableName, where: 'id=?', whereArgs: [taskId]);
        print("Sikeres törlés");
    }

      

    

    
  }
}
