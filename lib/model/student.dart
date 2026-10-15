class Student {
  int id;
  String name;
  String className;

  Student(this.id , this.name , this.className);
  static Student fromDb(Map<String , dynamic> row){
    int id = row['Id'] ?? 0;
    String name = row['Name']  ?? '' ;
    String className = row['Class'] ?? '';
    return Student(id, name,className );
  }

}