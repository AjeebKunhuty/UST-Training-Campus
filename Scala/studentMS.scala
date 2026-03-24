class StudentMS{
    case class Student(name: String)
    var studentList = List[Student]();
    def addStudent(name : String)={
    val student = Student(name);
    studentList :+= student;
    }
    def display = {
    println("Student list")
    for(student <- studentList){
    println(student.name);
    }
    }
    def search(name : String): Option[Student] = {
    var student : Option[Student] = None;
    for(person <- studentList){
    if(person.name == name){
    student = Some(person);
    }
    }
    student;
    }
    }