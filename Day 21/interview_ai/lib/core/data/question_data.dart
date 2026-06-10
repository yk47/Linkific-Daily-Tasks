import 'package:top_5_packages_app/models/question.dart';

class QuestionData {
  static final List<Question> flutterQuestions = [
    Question(id: 1, category: 'Flutter', questionText: 'What is the difference between StatefulWidget and StatelessWidget?', options: ['Mutable vs Immutable', 'Fast vs Slow', 'Both', 'None'], correctIndex: 0, explanation: 'StatefulWidget is mutable (can change state), StatelessWidget is immutable.'),
    Question(id: 2, category: 'Flutter', questionText: 'What widget is used for scrolling lists?', options: ['Column', 'ListView', 'Row', 'Stack'], correctIndex: 1),
    Question(id: 3, category: 'Flutter', questionText: 'What is the build method in Flutter?', options: ['Renders UI', 'Fetches data', 'Handles gestures', 'Manages state'], correctIndex: 0),
    Question(id: 4, category: 'Flutter', questionText: 'What is the purpose of the pubspec.yaml file?', options: ['Manage dependencies', 'Run tests', 'Build APK', 'Design UI'], correctIndex: 0),
    Question(id: 5, category: 'Flutter', questionText: 'What is setState() used for?', options: ['Rebuild widget', 'Fetch API data', 'Navigate screens', 'Store data'], correctIndex: 0),
  ];

  static final List<Question> javaQuestions = [
    Question(id: 6, category: 'Java', questionText: 'What is JVM?', options: ['Java Virtual Machine', 'Java Variable Manager', 'Java Version Model', 'None'], correctIndex: 0),
    Question(id: 7, category: 'Java', questionText: 'What is inheritance in Java?', options: ['Acquiring properties from parent', 'Creating objects', 'Hiding data', 'Overloading methods'], correctIndex: 0),
    Question(id: 8, category: 'Java', questionText: 'What is the main method signature in Java?', options: ['public static void main(String[])', 'static void main()', 'public void main()', 'void main(String[])'], correctIndex: 0),
    Question(id: 9, category: 'Java', questionText: 'What is an interface in Java?', options: ['Abstract type with methods', 'Concrete class', 'Data structure', 'Loop'], correctIndex: 0),
    Question(id: 10, category: 'Java', questionText: 'What is polymorphism?', options: ['Many forms', 'Single form', 'No form', 'Abstract'], correctIndex: 0),
  ];

  static final List<Question> pythonQuestions = [
    Question(id: 11, category: 'Python', questionText: 'What is a list in Python?', options: ['Ordered collection', 'Unordered collection', 'Key-value pairs', 'None'], correctIndex: 0),
    Question(id: 12, category: 'Python', questionText: 'What is the use of def keyword?', options: ['Define function', 'Define class', 'Define variable', 'Define loop'], correctIndex: 0),
    Question(id: 13, category: 'Python', questionText: 'What is a dictionary in Python?', options: ['Key-value pairs', 'Ordered list', 'Tuple', 'Set'], correctIndex: 0),
    Question(id: 14, category: 'Python', questionText: 'What is \'self\' in Python?', options: ['Instance reference', 'Class reference', 'Module reference', 'Function'], correctIndex: 0),
    Question(id: 15, category: 'Python', questionText: 'What is list comprehension?', options: ['Compact list creation', 'List sorting', 'List copying', 'List deletion'], correctIndex: 0),
  ];

  static final List<Question> cyberSecurityQuestions = [
    Question(id: 16, category: 'Cyber Security', questionText: 'What is phishing?', options: ['Fraudulent emails', 'Secure login', 'Data encryption', 'Firewall'], correctIndex: 0),
    Question(id: 17, category: 'Cyber Security', questionText: 'What is a firewall?', options: ['Network security system', 'Virus', 'Browser', 'Protocol'], correctIndex: 0),
    Question(id: 18, category: 'Cyber Security', questionText: 'What is encryption?', options: ['Data encoding', 'Data deletion', 'Data copying', 'Data sorting'], correctIndex: 0),
    Question(id: 19, category: 'Cyber Security', questionText: 'What is a DDoS attack?', options: ['Overwhelming server traffic', 'Data theft', 'Password cracking', 'Virus spread'], correctIndex: 0),
    Question(id: 20, category: 'Cyber Security', questionText: 'What is 2FA?', options: ['Two-factor authentication', 'File access', 'Data format', 'Network type'], correctIndex: 0),
  ];

  static final List<Question> aptitudeQuestions = [
    Question(id: 21, category: 'Percentage', questionText: 'What is 20% of 250?', options: ['50', '25', '75', '100'], correctIndex: 0),
    Question(id: 22, category: 'Profit & Loss', questionText: 'If CP = 100 and SP = 120, what is profit %?', options: ['20%', '10%', '15%', '25%'], correctIndex: 0),
    Question(id: 23, category: 'Time & Work', questionText: 'A can do work in 5 days, B in 10 days. How many days together?', options: ['3.33', '5', '7.5', '15'], correctIndex: 0),
    Question(id: 24, category: 'Probability', questionText: 'What is probability of getting heads in coin toss?', options: ['0.5', '0.25', '0.75', '1.0'], correctIndex: 0),
    Question(id: 25, category: 'Logical Reasoning', questionText: 'Find next: 2, 4, 6, 8, ?', options: ['10', '9', '12', '14'], correctIndex: 0),
  ];

  static final List<String> hrQuestions = [
    'Tell me about yourself.',
    'Why should we hire you?',
    'What are your strengths and weaknesses?',
    'Where do you see yourself in 5 years?',
    'Why do you want to leave your current job?',
    'Tell me about a challenge you faced and how you handled it.',
    'How do you handle pressure or stress?',
    'What is your greatest achievement?',
    'Describe your ideal work environment.',
    'Why did you choose this career path?',
  ];

  static List<Question> getQuestionsByCategory(String category) {
    switch (category) {
      case 'Flutter':
        return flutterQuestions;
      case 'Java':
        return javaQuestions;
      case 'Python':
        return pythonQuestions;
      case 'Cyber Security':
        return cyberSecurityQuestions;
      case 'Aptitude':
        return aptitudeQuestions;
      default:
        return [];
    }
  }

  static List<String> get allCategories => [
        'Flutter', 'Java', 'Python', 'Cyber Security',
      ];

  static List<String> get hrInterviewQuestions => hrQuestions;

  static Question getDailyTechnical() {
    return flutterQuestions[DateTime.now().day % flutterQuestions.length];
  }

  static Question getDailyAptitude() {
    return aptitudeQuestions[DateTime.now().day % aptitudeQuestions.length];
  }

  static String getDailyHR() {
    return hrQuestions[DateTime.now().day % hrQuestions.length];
  }
}