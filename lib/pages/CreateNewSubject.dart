import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:planner_lite/controllers/ClassSubject_controller.dart';
import 'package:planner_lite/model/Subject.dart';

class CreateNewSubject extends StatefulWidget {
  const CreateNewSubject({super.key});

  @override
  State<CreateNewSubject> createState() => _CreateNewSubjectState();
}

class _CreateNewSubjectState extends State<CreateNewSubject> {

  final ClassSubjectController _classSubjectController = Get.put(ClassSubjectController());

  Color choosenColor = Colors.red;

  late int _selectedColorAvatar = 0;

  @override
  void initState() {
    super.initState();
    
  }

  List<String> subjects = <String>["Irodalom", "Nyelvtan", "Matek", "Történelem", "Hittan", "Biológia", "Fizika", "Földrajz", "Kémia", "Német", "Secondlang", "Ének", "Rajz", "Informatika", "Testnevelés", "Ofői"];

  String _selectedIconAvatar = "";

  TextEditingController _subjectNameController = TextEditingController();
  TextEditingController _subjectColorController = TextEditingController();
  TextEditingController _subjectIconController = TextEditingController();

  List<Color> szinek = 
  [Color(0xffff7a5b),
  Color(0xfff44236),
  Color(0xffb90005),
  Color(0xffff6090),
  Color(0xffea1e63),
  Color(0xffaf0039),
  Color(0xffce5de1),
  Color(0xff9c28b1),
  Color(0xff6a0080),
  Color(0xff9767ee),
  Color(0xff673bb7),
  Color(0xff320c86),
  Color(0xff757de8),
  Color(0xff3f51b5),
  Color(0xff002983),
  Color(0xff6dc6fe),
  Color(0xff2196f3),
  Color(0xff006ac0),
  Color(0xff62efff),
  Color(0xff00bcd5),
  Color(0xff008ba2),
  Color(0xff52c7b7),
  Color(0xff009788),
  Color(0xff00685f),
  Color(0xff80e27f),
  Color(0xff4cb050),
  Color(0xff087f23),
  Color(0xffbef679),
  Color(0xff8bc24a),
  Color(0xff5a9215),
  Color(0xffffff6d),
  Color(0xffcddc39),
  Color(0xff99ab01),
  Color(0xfffeff71),
  Color(0xffffeb3c),
  Color(0xffc8b800),
  Color(0xfffff34f),
  Color(0xfffec107),
  Color(0xffc89100),
  Color(0xffffc847),
  Color(0xffff9700),
  Color(0xffc66901),
  Color(0xfffe8a4f),
  Color(0xfffe5722),
  Color(0xffc41c01),
  Color(0xffa98273),
  Color(0xff795547),
  Color(0xff4a2c21),
  Color(0xffcfcfcf),
  Color(0xff9e9e9e),
  Color(0xff707070),
  Color(0xff8dadba),
  Color(0xff607d8b),
  Color(0xff34525d)

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Új tantárgy"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _subjectNameController,
              style: TextStyle(
                fontSize: 28
              ),
              decoration: InputDecoration(
                  hintText: "Név hozzáadása",
                  border: InputBorder.none
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(maxRadius: 10, backgroundColor: szinek[_selectedColorAvatar],),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      readOnly: true,
                      style: TextStyle(
                        fontSize: 22
                      ),
                      decoration: InputDecoration(
                          hintText: "Válassz egy színt!",
                          border: InputBorder.none
                      ),
                      onTap: () => pickColor(context)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _selectedIconAvatar != "" ? SvgPicture.asset(
                    "lib/icons/${_selectedIconAvatar.toString().toLowerCase()}.svg",
                    height: 30,
                    width: 30,
                    ):SvgPicture.asset(
                    "lib/icons/question.svg",
                    color: Colors.white,
                    height: 30,
                    width: 30,
                    )
                    //TODO ide
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      readOnly: true,
                      style: TextStyle(
                        fontSize: 22
                      ),
                      decoration: InputDecoration(
                          hintText: "Válassz egy ikont!",
                          border: InputBorder.none
                      ),
                      onTap: () => pickSubjectIcon(context)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: FilledButton.tonal(
          onPressed: () async {
            _classSubjectController.addSubject(
              subjectModal: Subject(
                subject: _subjectNameController.text,
                subjectColor: _subjectColorController.text,
                subjectIcon: _subjectIconController.text,
                teacherName: ""
              )
            );
            _classSubjectController.getSubjects();
            Get.back();

          },
          child: const Center(
            child: Text('Hozzáadás'),
          ),
        ),
      ),
    );
  }

  Future<void> pickSubjectIcon(BuildContext context) => 
    showModalBottomSheet(
      context: context,
      builder: (context) => 
         Container(
          padding: EdgeInsets.symmetric(vertical: 30),
           width: double.maxFinite,
           child: SingleChildScrollView( // Használj egy SingleChildScrollView-t a Wrap helyett
             scrollDirection: Axis.vertical, // Állítsd be az Axis.horizontal-t, hogy vízszintesen görgethető legyen
             child: Column(
               mainAxisSize: MainAxisSize.min, // Változtasd a MainAxisSize-t min-re, hogy csak annyi helyet foglaljon el, amennyire szükség van
               children: [
                 Wrap(
                   children: List.generate(
                     subjects.length, 
                     (int index){
                       return GestureDetector(
                         onTap: (){
                           setState(() {
                             _selectedIconAvatar = subjects[index].toString().toLowerCase();
                             _subjectIconController.text = _selectedIconAvatar;
                           });
                           print(_selectedIconAvatar);
                           Get.back();
                         },
                         child:
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "lib/icons/${subjects[index].toString().toLowerCase()}.svg",
                              height: 50,
                              width: 50,
                              ),
                          )
                       );
                     }),
                 )
               ],
             ),
           )
         )
    );

  Future<void> pickColor(BuildContext context) => 
    showModalBottomSheet(
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
              Wrap(
                children: List.generate(
                  szinek.length, 
                  (int index){
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedColorAvatar = index;
                          _subjectColorController.text = szinek[_selectedColorAvatar].toString();
                        });
                        print(_selectedColorAvatar);
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            color: szinek[index],
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                      ),
                    );
                  }),
              )
            ]
          );
        }

      )
         
    );


}