import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/user.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<User?> logInWithEmailAndPassword(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> uploadProfileImage(
      File image, String userId, String email, String name) async {
    try {
      String fileName =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}.png';
      var ref = _firebaseStorage.ref().child(fileName);
      await ref.putFile(image);
      String downloadUrl = await ref.getDownloadURL();
      await _firestore.collection('userInfo').doc(userId).set({
        'email': email,
        'name': name,
        'isOnline': false,
        'uuid': userId,
        'lastOnlineStatus': DateTime.now().millisecondsSinceEpoch,
        'imageUrl': downloadUrl,
      });
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<List<UserInfoModel>> loadAllUsersGroup() async {
    var snapshot = await _firestore.collection('userInfo').get();
    List<UserInfoModel> users = snapshot.docs.map((doc) {
      return UserInfoModel(
        name: doc['name'],
        email: doc['email'],
        uuid: doc['uuid'],
        imageUrl: doc['imageUrl'],
        isOnline: doc['onlineStatus'],
        lastOnline: (doc['lastOnlineStatus']),
      );
    }).toList();

    return users;
  }
}
