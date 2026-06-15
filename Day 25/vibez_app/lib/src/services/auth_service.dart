import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../config/app_config.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseService().firestore;

  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseService.authStateChanges;

  UserModel? _currentUserModel;
  UserModel? get currentUserModel => _currentUserModel;

  // Get current user data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    final user = _firebaseService.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection(AppConfig.usersCollection)
          .doc(user.uid)
          .get();
      
      if (doc.exists) {
        _currentUserModel = UserModel.fromMap(doc.data()!);
        return _currentUserModel;
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  // Stream user data for real-time updates
  Stream<UserModel?> streamCurrentUserData() {
    final user = _firebaseService.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection(AppConfig.usersCollection)
        .doc(user.uid)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            _currentUserModel = UserModel.fromMap(doc.data()!);
            return _currentUserModel;
          }
          return null;
        });
  }

  // Register new user
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _firebaseService.registerWithEmailAndPassword(
      email,
      password,
    );

    final user = credential.user!;
    final userModel = UserModel(
      uid: user.uid,
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      isOnline: true,
    );

    // Save user data to Firestore
    await _firestore
        .collection(AppConfig.usersCollection)
        .doc(user.uid)
        .set(userModel.toMap());

    // Update display name in Firebase Auth
    await user.updateDisplayName(displayName);
    await user.reload();

    _currentUserModel = userModel;
    return userModel;
  }

  // Sign in existing user
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseService.signInWithEmailAndPassword(email, password);
    
    final userModel = await getCurrentUserData();
    if (userModel == null) {
      throw Exception('User data not found');
    }

    // Update online status
    await updateOnlineStatus(true);

    return userModel;
  }

  // Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google sign in was cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseService.auth.signInWithCredential(credential);
    final user = userCredential.user!;

    // Check if user already exists in Firestore
    final doc = await _firestore
        .collection(AppConfig.usersCollection)
        .doc(user.uid)
        .get();

    if (doc.exists) {
      _currentUserModel = UserModel.fromMap(doc.data()!);
      await updateOnlineStatus(true);
      return _currentUserModel!;
    }

    // Create new user in Firestore
    final userModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Google User',
      photoURL: user.photoURL,
      createdAt: DateTime.now(),
      isOnline: true,
    );

    await _firestore
        .collection(AppConfig.usersCollection)
        .doc(user.uid)
        .set(userModel.toMap());

    _currentUserModel = userModel;
    return userModel;
  }

  // Sign out
  Future<void> signOut() async {
    // Update online status before signing out
    await updateOnlineStatus(false);
    _currentUserModel = null;
    await _firebaseService.signOut();
  }

  // Update online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    final user = _firebaseService.currentUser;
    if (user == null) return;

    await _firestore.collection(AppConfig.usersCollection).doc(user.uid).update({
      'isOnline': isOnline,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Get user data by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConfig.usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  // Stream user data
  Stream<UserModel> streamUserData(String userId) {
    return _firestore
        .collection(AppConfig.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data()!));
  }

  // Search users
  Stream<List<UserModel>> searchUsers(String query) {
    return _firestore
        .collection(AppConfig.usersCollection)
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(AppConfig.usersPerPage)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? bio,
    String? phoneNumber,
  }) async {
    final user = _firebaseService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (photoURL != null) updates['photoURL'] = photoURL;
    if (bio != null) updates['bio'] = bio;
    if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;

    await _firestore
        .collection(AppConfig.usersCollection)
        .doc(user.uid)
        .update(updates);

    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }
    if (photoURL != null) {
      await user.updatePhotoURL(photoURL);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseService.sendPasswordResetEmail(email);
  }
}