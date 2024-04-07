import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/database/database_service.dart';
import 'package:planner_lite/database/subject_db.dart';
import 'package:planner_lite/pages/CreateClass.dart';
import 'package:planner_lite/pages/Preferences.dart';
import 'package:planner_lite/pages/TaskPage.dart';
import 'pages/timetable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database;
  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());
  _classSubjectController.getClasses();
  _classSubjectController.getTasks();

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

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());
  int _currentPageIndex  = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    TimeTablePage(),
    TaskPage()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
        AppBar(
          title: Text("Planner Lite", style: TextStyle(fontSize: 32),),
          actions: [
            IconButton(onPressed: () async {
              await Get.to(() => CreateClass());
              _classSubjectController.getClasses();
              }, 
              icon: Icon(Icons.add))
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
}
