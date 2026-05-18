import 'dart:io';

void main() {
  print("=== Simple Calculator ===");

  // Taking first number input
  stdout.write("Enter first number: ");
  double num1 = double.parse(stdin.readLineSync()!);

  // Taking operator input
  stdout.write("Enter operator (+, -, *, /): ");
  String operator = stdin.readLineSync()!;

  // Taking second number input
  stdout.write("Enter second number: ");
  double num2 = double.parse(stdin.readLineSync()!);

  double result;

  // Performing calculation
  switch (operator) {
    case "+":
      result = num1 + num2;
      break;

    case "-":
      result = num1 - num2;
      break;

    case "*":
      result = num1 * num2;
      break;

    case "/":
      if (num2 != 0) {
        result = num1 / num2;
      } else {
        print("Error: Division by zero is not allowed.");
        return;
      }
      break;

    default:
      print("Invalid operator!");
      return;
  }

  // Display result
  print("Result: $result");
}
