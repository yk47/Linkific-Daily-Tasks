class AppConfig {
  // App Info
  static const String appName = 'Vibez';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Share Your Vibez';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String storiesCollection = 'stories';
  static const String likesCollection = 'likes';
  static const String commentsCollection = 'comments';
  static const String followsCollection = 'follows';
  static const String notificationsCollection = 'notifications';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  
  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String postImagesPath = 'post_images';
  static const String storyImagesPath = 'story_images';
  static const String chatImagesPath = 'chat_images';
  
  // Post Features
  static const int maxPostCaptionLength = 2200;
  static const int maxPostsPerPage = 10;
  
  // Chat Features
  static const int maxMessageLength = 1000;
  static const int messagesPerPage = 30;
  static const int typingTimeoutSeconds = 3;
  
  // File Upload
  static const int maxFileSizeMB = 10;
  static const List<String> allowedImageTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'webp'
  ];
  
  // Pagination
  static const int usersPerPage = 20;
  static const int notificationsPerPage = 20;
}