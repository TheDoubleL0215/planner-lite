import 'package:get/get.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/model/ClassSubject.dart';
import 'package:planner_lite/model/Task.dart';
import 'package:planner_lite/pages/CreateClass.dart';

class ClassSubjectController extends GetxController{


  @override
  void onReady(){
    super.onReady();
  }

  var classesList = <ClassSubject>[].obs;
  var tasksList = <Task>[].obs;

  Future<int> addClass({ClassSubject? classSubject}) async{
    return await SubjectsDB.insert(classSubject);
  }

  Future<int> addTask({Task? task}) async{
    return await SubjectsDB.insertTask(task);
  }

  void updateTask({required Task task, required int taskId}) async{
    await SubjectsDB.updateTask(task, taskId);
    getClasses();
    getTasks();
  }


  void getClasses() async {
    List<Map<String, dynamic>> classes = await SubjectsDB.query();
    print(classes);
    classesList.assignAll(classes.map((data) => new ClassSubject.fromJson(data)).toList());
    print("Minden feladat: $classesList");
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await SubjectsDB.queryTasks();
    print(tasks);
    tasksList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
    print("Minden feladat: $tasksList");
  }

  void checkTask(int taskId) async{
    await SubjectsDB.checkTask(taskId);
    getClasses();
    getTasks();
  }

  void delete(int classId) async{
    await SubjectsDB.delete(classId);
  }

  void removeTask(int taskId) async{
    await SubjectsDB.removeTask(taskId);
    getClasses();
    getTasks();
  }

  void toggleHomeworkFlag(int classId) async{
    await SubjectsDB.toggleHomeworkFlag(classId, "0");
    getClasses();
  }

  void addHomework(int classId)async{
    await SubjectsDB.addHomework(classId);
    //print(subj);
    getClasses();
    getTasks();
  }

}