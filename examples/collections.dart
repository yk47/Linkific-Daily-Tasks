void main() {
  // List (Ordered collection)
  List<String> fruits = ["Apple", "Banana", "Mango"];

  print("Fruits List:");
  print(fruits);

  // Adding item to list
  fruits.add("Orange");
  print("Updated Fruits List: $fruits");

  // Accessing list item
  print("First Fruit: ${fruits[0]}");

  // Set (Unique values only)
  Set<int> numbers = {1, 2, 3, 4, 4, 5};

  print("\nNumbers Set:");
  print(numbers);

  // Adding item to set
  numbers.add(6);
  print("Updated Set: $numbers");

  // Map (Key-Value pairs)
  Map<String, dynamic> user = {
    "name": "Yash",
    "age": 26,
    "isDeveloper": true,
  };

  print("\nUser Map:");
  print(user);

  // Accessing map values
  print("User Name: ${user["name"]}");

  // Updating map value
  user["age"] = 27;
  print("Updated User Map: $user");

  // Loop through list
  print("\nLooping through fruits:");
  for (String fruit in fruits) {
    print(fruit);
  }
}
