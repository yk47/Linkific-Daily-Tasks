void main() {
  // Nullable variable (? means it can be null)
  String? name;

  // Assigning value later
  name = "Yash";

  print("Name: $name");

  // Null-aware operator (??)
  String? city;
  String userCity = city ?? "Mumbai";

  print("City: $userCity");

  // Null assertion operator (!)
  String? country = "India";
  print("Country: ${country!.toUpperCase()}");

  // Late keyword
  late String message;
  message = "Welcome to Dart Null Safety";

  print(message);

  // Optional nullable parameter
  greetUser();
  greetUser("Rahul");
}

/// Nullable parameter function
void greetUser([String? name]) {
  print("Hello, ${name ?? "Guest"}!");
}
