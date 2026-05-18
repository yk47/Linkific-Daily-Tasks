import 'dart:io';

void main() {
  List<String> tasks = [];

  while (true) {
    print("\n===== TO-DO LIST APP =====");
    print("1. Add Task");
    print("2. View Tasks");
    print("3. Remove Task");
    print("4. Exit");

    stdout.write("Choose an option: ");
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        addTask(tasks);
        break;

      case '2':
        viewTasks(tasks);
        break;

      case '3':
        removeTask(tasks);
        break;

      case '4':
        print("Exiting To-Do App...");
        return;

      default:
        print("Invalid option! Please try again.");
    }
  }
}

/// Add task function
void addTask(List<String> tasks) {
  stdout.write("Enter task: ");
  String task = stdin.readLineSync()!;

  tasks.add(task);
  print("Task added successfully!");
}

/// View tasks function
void viewTasks(List<String> tasks) {
  if (tasks.isEmpty) {
    print("No tasks available.");
    return;
  }

  print("\nYour Tasks:");
  for (int i = 0; i < tasks.length; i++) {
    print("${i + 1}. ${tasks[i]}");
  }
}

/// Remove task function
void removeTask(List<String> tasks) {
  if (tasks.isEmpty) {
    print("No tasks to remove.");
    return;
  }

  viewTasks(tasks);

  stdout.write("Enter task number to remove: ");
  int index = int.parse(stdin.readLineSync()!);

  if (index > 0 && index <= tasks.length) {
    String removedTask = tasks.removeAt(index - 1);
    print("Removed: $removedTask");
  } else {
    print("Invalid task number.");
  }
}
