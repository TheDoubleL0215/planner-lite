import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planner_lite/pages/ClassTile.dart';
import 'package:planner_lite/pages/DayPages/DayLoader.dart';



class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key}); 

    @override
  State<TimeTablePage> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<TimeTablePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Business',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle daySliderFont =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().weekday);
    return DefaultTabController(
      initialIndex: DateTime.now().weekday >= 6 ? 0 : DateTime.now().weekday,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            labelStyle: daySliderFont,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(
                text: "H",
              ),
              Tab(
                text: "K",
              ),
              Tab(
                text: "Sz",
              ),
              Tab(
                text: "Cs",
              ),
              Tab(
                text: "P",
              ),
            ],
          ),
        ),
        body:
          TabBarView(
          children: <Widget>[
            DayLoader(loadDayValue: 0,),
            DayLoader(loadDayValue: 1,),
            DayLoader(loadDayValue: 2,),
            DayLoader(loadDayValue: 3,),
            DayLoader(loadDayValue: 4,),
          ],
        )
      ),
    );
  }
}