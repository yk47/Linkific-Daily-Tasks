void main() {
  // Creating an object
  Person person = Person("Yash", 26);

  // Accessing methods
  person.displayInfo();

  // Inheritance example
  Student student = Student("Rahul", 20, "Flutter Development");
  student.displayInfo();
}

/// Parent Class
class Person {
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Method
  void displayInfo() {
    print("Name: $name");
    print("Age: $age");
  }
}

/// Child Class (Inheritance)
class Student extends Person {
  String course;

  // Constructor using super
  Student(String name, int age, this.course)
      : super(name, age);

  // Method overriding
  @override
  void displayInfo() {
    super.displayInfo();
    print("Course: $course");
  }
}
