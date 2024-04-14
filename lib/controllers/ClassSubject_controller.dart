import 'package:get/get.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/model/ClassSubject.dart';
import 'package:planner_lite/model/Subject.dart';
import 'package:planner_lite/model/Task.dart';
import 'package:planner_lite/pages/CreateClass.dart';

class ClassSubjectController extends GetxController{


  @override
  void onReady(){
    super.onReady();
  }

  var classesList = <ClassSubject>[].obs;
  var tasksList = <Task>[].obs;
  var subjectsList = <Subject>[].obs;
  RxInt currentDayPageSelected = 0.obs;

  void addClass({ClassSubject? classSubject}) async{
    await SubjectsDB.insert(classSubject);
    getClasses();
  }

  Future<int> addTask({Task? task}) async{
    return await SubjectsDB.insertTask(task);
  }

  Future<int> addSubject({Subject? subjectModal}) async{
    return await SubjectsDB.insertSubject(subjectModal);
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
    print("Minden óra: $classesList");
  }

  void getSubjects() async {
    List<Map<String, dynamic>> subjects = await SubjectsDB.querySubjects();
    print(subjects);
    subjectsList.assignAll(subjects.map((data) => new Subject.fromJson(data)).toList());
    print("Minden tantárgy: $subjectsList");
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

  void deleteSubject(int subjectId) async{
    await SubjectsDB.deleteSubject(subjectId);
    getClasses();
    getSubjects();
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

  void addHomework(int classId, String description)async{
    await SubjectsDB.addHomework(classId, description);
    //print(subj);
    getClasses();
    getTasks();
  }

}