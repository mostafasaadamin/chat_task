import 'package:chat/screens/chat/chat_screen.dart';
import 'package:chat/screens/login/login_screen.dart';
import 'package:chat/screens/splash/splash_screen.dart';
import 'package:chat/screens/users/users_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helper/shared_prefes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Chat UI',
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Use system theme (or customize)
      home:SplashScreen(),
    );
  }


}
