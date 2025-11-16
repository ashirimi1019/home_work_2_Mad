import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing a chat message in a message board.
/// Contains message text, sender information, board association,
/// and timestamp for ordering and display.
class Message {
  final String id;
  final String boardId;
  final String text;
  final String senderUid;
  final String senderDisplayName;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.boardId,
    required this.text,
    required this.senderUid,
    required this.senderDisplayName,
    required this.timestamp,
  });

  /// Creates a Message from a Firestore document snapshot
  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      boardId: data['boardId'] ?? '',
      text: data['text'] ?? '',
      senderUid: data['senderUid'] ?? '',
      senderDisplayName: data['senderDisplayName'] ?? 'Unknown User',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts Message to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'boardId': boardId,
      'text': text,
      'senderUid': senderUid,
      'senderDisplayName': senderDisplayName,
      'timestamp': FieldValue.serverTimestamp(), // Use server timestamp
    };
  }

  /// Creates a copy of this Message with updated fields
  Message copyWith({
    String? id,
    String? boardId,
    String? text,
    String? senderUid,
    String? senderDisplayName,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      boardId: boardId ?? this.boardId,
      text: text ?? this.text,
      senderUid: senderUid ?? this.senderUid,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
