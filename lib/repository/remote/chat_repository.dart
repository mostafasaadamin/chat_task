import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> updateUserOnlineStatus(String userUuid, bool onlineStatus) async {
    CollectionReference usersCollection = _fireStore.collection('userInfo');
    QuerySnapshot querySnapshot = await usersCollection.where('uuid', isEqualTo: userUuid).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      await userDoc.reference.update({'onlineStatus': onlineStatus});
      await userDoc.reference.update({'lastOnlineStatus': DateTime.now().millisecondsSinceEpoch});
    }

  }
}