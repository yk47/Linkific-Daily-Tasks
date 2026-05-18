void main() async {
  print("App Started");

  // Fetch fake user data
  String userData = await fetchUserData();

  print(userData);
  print("App Finished");
}

/// Simulates an API call
Future<String> fetchUserData() async {
  print("Fetching data from API...");

  // Simulating network delay
  await Future.delayed(Duration(seconds: 3));

  return "User data received successfully!";
}
