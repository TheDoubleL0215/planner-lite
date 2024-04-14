import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner_lite/pages/CreateNewSubject.dart';
import 'package:planner_lite/pages/EditSubjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
   Settings({super.key, required this.advancedHomeworkState});

  final bool advancedHomeworkState;

  @override
  State<Settings> createState() => SettingsState();
}


class SettingsState extends State<Settings> {

  bool _testValue = false;

  @override
  void initState() {
    super.initState();
    _testValue = widget.advancedHomeworkState;
  }


  @override
  _saveAdvancedHomeworking(bool currValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(currValue){
      await prefs.setBool("advancedHomework", true);
      print("Mentve false");
    }else{
      await prefs.setBool("advancedHomework", false);
      print("Mentve true");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beállítások"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Tantárgyak szerkesztése
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.onSecondary,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Theme.of(context).colorScheme.onSecondary,
                onTap: () async {
                  await Get.to(() => EditSubject());
                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Tantárgyak szerkesztése"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            // Részletes házifeladat hozzáadás kapcsoló
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.onSecondary,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Theme.of(context).colorScheme.onSecondary,
                onTap: () async {},
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Részletes házifeladat hozzáadás'),
                      value: _testValue,
                      onChanged: (bool value) {
                        setState(() {
                          _testValue = value;
                        });
                        _saveAdvancedHomeworking(value);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}