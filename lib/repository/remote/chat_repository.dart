import 'dart:io';
import 'package:chat/screens/chat/bloc/chars_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> updateUserOnlineStatus(String userUuid,
      bool onlineStatus) async {
    CollectionReference usersCollection = _fireStore.collection('userInfo');
    QuerySnapshot querySnapshot = await usersCollection.where(
        'uuid', isEqualTo: userUuid).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      await userDoc.reference.update({'onlineStatus': onlineStatus});
      await userDoc.reference.update({'lastOnlineStatus': DateTime
          .now()
          .millisecondsSinceEpoch});
    }
  }

  Future<CollectionReference<Map<String, dynamic>>> loadAllChats(
      {required String userUuid, required String userTargetId}) async{
    final chatKey = '${userUuid}_$userTargetId';
    final messagesRef = _fireStore.collection('chatMessages')
        .doc(chatKey)
        .collection('messages');
    return messagesRef;
  }


  Future<void> sendChatMessage(
      {required String userUuid, required String userTargetId, required String message, required String userName}) async {
    String chatKey = '${userUuid}_$userTargetId';

    CollectionReference messages = FirebaseFirestore.instance.collection(
        'chatMessages');

    try {
      await messages.doc(chatKey).collection('messages').add({
        'senderId': userUuid,
        'receiverId': userTargetId,
        'message': message,
        'userName': userName,
        'timestamp': FieldValue.serverTimestamp(), // Add timestamp for ordering
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}