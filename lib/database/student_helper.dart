import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../model/student.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
class StudentHelper {
  StudentHelper.singletone();
  static final StudentHelper instance = StudentHelper.singletone();
  factory StudentHelper(){
    return instance;
  }
  static late Database _db;
  static final String TABLE_NAME = "Student";
  Future<Database> db() async{
    _db = await initDatabase();
    return _db;
  }
  Future<Database> initDatabase () async{
    final Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join( directory.path , "Student.db");
    Database db  = await openDatabase (dbPath , version: 1 , onCreate: (db , ver) => createTable(db , ver),
    );
    return db;
  }
  Future<void> createTable(Database db , int version) async{
    await db.execute("Create Table Student(Id integer Primary Key Autoincrement , Name Text , Class Text);");
  }
  Future<void>insertStudent(BuildContext context , Student s) async{
    Map<String , dynamic> student = {"Name" : s.name , "Class" : s.className};
    Database db = await this.db();
    int result = await db.insert(TABLE_NAME, student);
    print(result);
    if(result != -1){
      void showSnackBar(){
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message:
            'New Studentad  added in Our DataBase!',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
      showSnackBar();

    }else {
      void showSnackBar() {
        final snackBar = SnackBar(

          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message:
            'Data not Saved!',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
      showSnackBar();
    }

  }
  Future<List<Student>> getAllStudents() async{
    Database db = await this.db();
    var res = await db.query(TABLE_NAME);
    List<Student> data = [];
    for(final row in res){
      Student s = Student.fromDb(row);
      data.add(s);
      print("Student Id = ${s.id}");
      print("Student Name = ${s.name}");
      print("Student Class = ${s.className}");
    }
    return data;
  }
  void updateStudent(String id ,String name , String studentClass) async{
    Database db = await this.db();
    await db.update(TABLE_NAME,{"Name": name , "Class": studentClass}, where: "Id ==?" , whereArgs: [id],);
  }
  void deleStudent(String id) async{
    Database db = await this.db();
    await db.delete(TABLE_NAME,where: "Id ==?" , whereArgs: [id] );

  }
}
