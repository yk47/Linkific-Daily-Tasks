class NavigationRoutes {
  static const String shellHome = '/';
  static const String details = '/details';
  static const String drawerInfo = '/drawer-info';
  static const String homeStory = '/home/story';
  static const String exploreLab = '/explore/lab';
  static const String profileSettings = '/profile/settings';
}

class DetailArguments {
  const DetailArguments({
    required this.title,
    required this.message,
    required this.source,
  });

  final String title;
  final String message;
  final String source;
}
