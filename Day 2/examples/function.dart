void main() {
  // Calling functions
  greet();

  String message = greetUser("Yash");
  print(message);

  int sum = addNumbers(10, 20);
  print("Sum: $sum");

  double area = calculateArea(5.5, 4.0);
  print("Area: $area");

  introduce(name: "Yash", age: 26);
}

/// Simple function without parameters
void greet() {
  print("Hello, Welcome to Dart!");
}

/// Function with parameter and return value
String greetUser(String name) {
  return "Hello, $name!";
}

/// Function with multiple parameters
int addNumbers(int a, int b) {
  return a + b;
}

/// Function returning double value
double calculateArea(double length, double width) {
  return length * width;
}

/// Named parameters function
void introduce({required String name, required int age}) {
  print("My name is $name and I am $age years old.");
}
