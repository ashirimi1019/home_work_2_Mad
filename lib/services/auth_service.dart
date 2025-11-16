import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

/// Service class that handles Firebase Authentication and user profile management.
/// Provides methods for registration, login, logout, and profile updates.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Gets the current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Registers a new user with email/password and stores profile in Firestore
  /// 
  /// Parameters:
  /// - email: User's email address
  /// - password: User's password (min 6 characters)
  /// - firstName: User's first name
  /// - lastName: User's last name
  /// - role: User's role (e.g., "student", "admin")
  /// 
  /// Returns: The created AppUser object
  /// Throws: FirebaseAuthException on authentication failure
  Future<AppUser> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Create user profile in Firestore
      AppUser newUser = AppUser(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: role,
        registrationDateTime: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      return newUser;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Logs in a user with email and password
  /// 
  /// Parameters:
  /// - email: User's email address
  /// - password: User's password
  /// 
  /// Returns: The logged-in User object
  /// Throws: FirebaseAuthException on authentication failure
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Gets the current user's profile from Firestore
  /// 
  /// Returns: AppUser object or null if not found
  Future<AppUser?> getCurrentUserProfile() async {
    if (currentUser == null) return null;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Updates the current user's profile in Firestore
  /// 
  /// Parameters:
  /// - firstName: Updated first name
  /// - lastName: Updated last name
  /// - role: Updated role
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Updates the current user's password
  /// 
  /// Note: User must have recently signed in for this to work.
  /// May require re-authentication.
  /// 
  /// Parameters:
  /// - newPassword: The new password (min 6 characters)
  Future<void> updatePassword(String newPassword) async {
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      await currentUser!.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  /// Re-authenticates the current user with their email and password
  /// Required before sensitive operations like password change
  Future<void> reauthenticate(String email, String password) async {
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
    } catch (e) {
      throw Exception('Re-authentication failed: $e');
    }
  }
}
