import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/database/database_service.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/model/ClassSubject.dart';
import 'package:planner_lite/pages/CreateClass.dart';
import 'package:planner_lite/pages/CreateNewSubject.dart';
import 'package:planner_lite/pages/EditSubjects.dart';
import 'package:planner_lite/pages/Settings.dart';
import 'package:planner_lite/pages/TaskPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/timetable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database;
  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());
  _classSubjectController.getClasses();
  _classSubjectController.getTasks();
  _classSubjectController.getSubjects();

  runApp(GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Google Sans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark
          ),
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Google Sans',
      ),
      themeMode: ThemeMode.dark, 
      debugShowCheckedModeBanner: false,
      home: AppRootPage(),
    ));
}


class AppRootPage extends StatefulWidget {
  const AppRootPage({super.key});

  @override
  State<AppRootPage> createState() => _AppRootPageState();
  
}

class _AppRootPageState extends State<AppRootPage> {

  bool advancedHomeworkCurrentState = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      advancedHomeworkCurrentState = prefs.getBool("advancedHomework") ?? false;
    });
  }

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());

  int _currentPageIndex  = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    TimeTablePage(),
    TaskPage()
  ];

  int getHighestHour(){
    List<ClassSubject> filteredTimetable = _classSubjectController.classesList.where((element) => element.day == _classSubjectController.currentDayPageSelected.value).toList();
    // Ha nincs day:0 elem, akkor null értéket adunk vissza
    if (filteredTimetable.isEmpty) {
      int maxHour = 0;
      return maxHour;
    } else {
      // Keressük meg a legnagyobb hour értékkel rendelkező elemet
      int maxHour = -1;
      for(var single in filteredTimetable){
        print("Egyesével ${single.hour}");
        if(single.hour! > maxHour){
          maxHour = single.hour!;
        }
      }
      return maxHour;
    }

  }

  @override
  Widget build(BuildContext context) {

    Set _defaultDayState = {"H"};

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: 
        AppBar(
          title: Text("Planner Lite", style: TextStyle(fontSize: 32),),
          actions: [
            IconButton(onPressed: () async {
              addNewClassModal(context);
              _classSubjectController.getClasses();
              }, 
              icon: Icon(Icons.add)),

              IconButton(onPressed: () async {
              _loadData();
              await Get.to(() => Settings(advancedHomeworkState: advancedHomeworkCurrentState,));
              _classSubjectController.getClasses();
              }, 
              icon: Icon(Icons.settings_outlined))
            ],
      ),
      body: Center(
        child: _widgetOptions[_currentPageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(17, 17, 17, 1),
        indicatorColor: Theme.of(context).colorScheme.onPrimary,
        onDestinationSelected: (int index) {
          setState(() {
            HapticFeedback.vibrate();
            _currentPageIndex = index;
            print("EZ a current page" + "$_currentPageIndex");
          });
        },
        selectedIndex: _currentPageIndex,
        destinations:[
          NavigationDestination(
            icon: SvgPicture.asset(
              "lib/icons/CalendarIcon.svg",
              width: 24,
              height: 24,
            ),
            label: "Órarend",
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              "lib/icons/TaskIcon.svg",
              width: 24,
              height: 24,
            ),
            label: 'Teendők',
          ),
        ],
      ),
    );

  }
  Future<void> addNewClassModal(BuildContext context) {

    Set _defaultDayState = {"hétfő"};

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    TextEditingController _classPeriodEntryController = TextEditingController();

    bool _haveClassEntryError = true;

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>  DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.3,
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextButton.icon(
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateNewSubject()
                    ),
                  );}, 
                  icon: Icon(Icons.add), label: Text("Új tantárgy hozzáadása"),),
              ),
              Obx(() => Wrap(
                children: List.generate(
                  _classSubjectController.subjectsList.length,
                  (int index){
                    return ListTile(
                      onTap: () => {
                        print("Lent printelem ki! ${getHighestHour()}"),
                        _classSubjectController.addClass(
                          classSubject: ClassSubject(
                            subject: _classSubjectController.subjectsList[index].subject! ?? '',
                            day: _classSubjectController.currentDayPageSelected.value,
                            hour: getHighestHour()+1,
                            subjectColor: _classSubjectController.subjectsList[index].subjectColor!,
                            subjectIcon: _classSubjectController.subjectsList[index].subjectIcon!,
                            haveHomework: "0"
                          )),
                          Get.back(),

                      },

                      leading: CircleAvatar(maxRadius: 10, backgroundColor: Color(int.parse(_classSubjectController.subjectsList[index].subjectColor!.substring(6, _classSubjectController.subjectsList[index].subjectColor.toString().length-1)))),
                      title: Text(_classSubjectController.subjectsList[index].subject!),
                    );
                  }
                )
              )),
            ]
          );
        }

      )
         
    );
  }
    
}
