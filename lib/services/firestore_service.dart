import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

/// Service class that handles Cloud Firestore operations for messages and user profiles.
/// Provides methods for saving messages, streaming messages, and managing user data.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sends a message to a specific message board
  /// 
  /// Parameters:
  /// - boardId: The ID of the message board
  /// - text: The message text content
  /// - senderUid: The UID of the user sending the message
  /// - senderDisplayName: The display name of the sender
  /// 
  /// Returns: The document ID of the created message
  Future<String> sendMessage({
    required String boardId,
    required String text,
    required String senderUid,
    required String senderDisplayName,
  }) async {
    try {
      Message message = Message(
        id: '', // Will be set by Firestore
        boardId: boardId,
        text: text,
        senderUid: senderUid,
        senderDisplayName: senderDisplayName,
        timestamp: DateTime.now(),
      );

      DocumentReference docRef = await _firestore
          .collection('boards')
          .doc(boardId)
          .collection('messages')
          .add(message.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Streams messages for a specific board in real-time, ordered by timestamp
  /// 
  /// Parameters:
  /// - boardId: The ID of the message board
  /// 
  /// Returns: A stream of List<Message> that updates in real-time
  Stream<List<Message>> streamMessages(String boardId) {
    return _firestore
        .collection('boards')
        .doc(boardId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }

  /// Gets a user profile document from Firestore
  /// 
  /// Parameters:
  /// - uid: The user's UID
  /// 
  /// Returns: DocumentSnapshot containing user data
  Future<DocumentSnapshot> getUserProfile(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Updates a user profile document in Firestore
  /// 
  /// Parameters:
  /// - uid: The user's UID
  /// - data: Map of fields to update
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Deletes a message from a board (optional feature for moderation)
  /// 
  /// Parameters:
  /// - boardId: The ID of the message board
  /// - messageId: The ID of the message to delete
  Future<void> deleteMessage(String boardId, String messageId) async {
    try {
      await _firestore
          .collection('boards')
          .doc(boardId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }
}
