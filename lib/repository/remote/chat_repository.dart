import 'dart:io';
import 'package:chat/screens/chat/bloc/chars_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../const/const_strings.dart';

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
    final chatKey = [userUuid, userTargetId]..sort();
    final uniqueChatKey = '${chatKey[0]}_${chatKey[1]}';

    final messagesRef = _fireStore.collection('chatMessages')
        .doc(uniqueChatKey)
        .collection('messages');
    return messagesRef;
  }


  Future<void> sendChatMessage(
      {required String userUuid, required String userTargetId, required String message, required String userName}) async {
    final chatKey = [userUuid, userTargetId]..sort();
    final uniqueChatKey = '${chatKey[0]}_${chatKey[1]}';

    CollectionReference messages = FirebaseFirestore.instance.collection(
        'chatMessages');

    try {
      await messages.doc(uniqueChatKey).collection('messages').add({
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
  Future<void> sendTypingMessage({
    required String userUuid,
    required String userTargetId,
    required String typingMessageCode,
  }) async {
    final chatKey = [userUuid, userTargetId]..sort();
    final uniqueChatKey = '${chatKey[0]}_${chatKey[1]}';

    CollectionReference messages = FirebaseFirestore.instance.collection('chatMessages');

    try {
      QuerySnapshot querySnapshot = await messages
          .doc(uniqueChatKey)
          .collection('messages')
          .where('message', isEqualTo: typingMessageCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        await messages.doc(uniqueChatKey).collection('messages').doc(docId).update({
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        await messages.doc(uniqueChatKey).collection('messages').add({
          'senderId': userUuid,
          'receiverId': userTargetId,
          'message': typingMessageCode,
          'userName': "",
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error sending typing message: $e");
    }
  }

  Future<void> deleteTypingMessage({
    required String userUuid,
    required String userTargetId,
    required String typingMessageCode,
  }) async {
    final chatKey = [userUuid, userTargetId]..sort(); // Sort to make a unique key
    final uniqueChatKey = '${chatKey[0]}_${chatKey[1]}';

    CollectionReference messages = FirebaseFirestore.instance.collection('chatMessages');

    try {
      QuerySnapshot querySnapshot = await messages
          .doc(uniqueChatKey)
          .collection('messages')
          .where('message', isEqualTo: typingMessageCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        await messages.doc(uniqueChatKey).collection('messages').doc(docId).delete();
        print("Typing message deleted successfully.");
      } else {
        print("No typing message found with the given code.");
      }
    } catch (e) {
      print("Error deleting typing message: $e");
    }
  }

}