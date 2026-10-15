import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../database/student_helper.dart';
import '../model/student.dart';

class StudentScreen extends StatefulWidget {

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  List<Student> student = [];
  int? selectedStudentId;
  @override

  void initState(){
    super.initState();
    initStudent();
  }
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Student DataBase" , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          Container(
            width: width * 0.9,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue],
                begin: Alignment.centerLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // YAHAN Student Name + Class + Save button aayenge
              ],
            ),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Student Name",
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: classController,
            decoration: InputDecoration(
              labelText: "Student Class",
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(onPressed: ()=> saveData(), child: Text("Save Student")),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: student.length,
            itemBuilder: (context, index) {
              Student s = student[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Student Name: ${s.name}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Class: ${s.className}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => updateStudent(s),
                              child: const Text("Update"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => deleteData(s.id.toString()),
                              child: const Text("Delete"),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void saveData() async {
    StudentHelper studentHelper = StudentHelper();

    String name = nameController.text;
    String className = classController.text;

    if (selectedStudentId != null) {
      studentHelper.updateStudent(
        selectedStudentId.toString(),
        name,
        className,
      );

      selectedStudentId = null;
    } else {
      Student s = Student(0, name, className);
      await studentHelper.insertStudent(context, s);
    }

    student = await studentHelper.getAllStudents();

    nameController.clear();
    classController.clear();

    setState(() {});
  }

  void getData() {
    StudentHelper studentHelper = StudentHelper();
    studentHelper.getAllStudents();
  }

  void updateStudent(Student s) {
    nameController.text = s.name;
    classController.text = s.className;
    selectedStudentId = s.id;

    initStudent();
  }
  void deleteData(String id) {
    StudentHelper studentHelper = StudentHelper();
    studentHelper.deleStudent(id);
    initStudent();
  }
  void initStudent() async{
    StudentHelper studentHelper = StudentHelper();
    student = await studentHelper.getAllStudents();
    setState(() {

    });
  }
}
