import 'package:chat/repository/remote/auth_repository.dart';
import 'package:chat/repository/remote/chat_repository.dart';
import 'package:chat/screens/chat/chat_screen.dart';
import 'package:chat/screens/login/login_screen.dart';
import 'package:chat/screens/splash/splash_screen.dart';
import 'package:chat/screens/users/bloc/users_list_state.dart';
import 'package:chat/screens/users/users_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'helper/shared_prefes.dart';
import 'screens/users/bloc/users_list_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp( BlocProvider(
      create: (_) => UsersBloc(chatRepository: ChatRepository(),authRepository:AuthRepository()),
      child: ChatApp()));
}

class ChatApp extends StatefulWidget {
  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {

  @override
  Widget build(BuildContext context) {
   return  GetMaterialApp(
     themeMode:ThemeMode.system,
     theme: ThemeData.light(),
     darkTheme: ThemeData.dark(),
     home: SplashScreen(),
   );
  }


}
