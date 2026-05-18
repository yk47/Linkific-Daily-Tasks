void main() async {
  print("Program Started");

  // Calling async function
  String data = await fetchUserData();
  print(data);

  print("Program Ended");
}

/// Async function
Future<String> fetchUserData() async {
  print("Fetching user data...");

  // Simulating API delay
  await Future.delayed(Duration(seconds: 3));

  return "User data loaded successfully!";
}
