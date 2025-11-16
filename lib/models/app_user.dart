import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing a user in the Message Board app.
/// Stores user profile information including authentication uid,
/// personal details, role, and registration timestamp.
class AppUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final DateTime registrationDateTime;

  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.registrationDateTime,
  });

  /// Creates an AppUser from a Firestore document snapshot
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
      registrationDateTime: (data['registrationDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts AppUser to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'registrationDateTime': Timestamp.fromDate(registrationDateTime),
    };
  }

  /// Returns the full display name
  String get displayName => '$firstName $lastName';

  /// Creates a copy of this AppUser with updated fields
  AppUser copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    DateTime? registrationDateTime,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      registrationDateTime: registrationDateTime ?? this.registrationDateTime,
    );
  }
}
