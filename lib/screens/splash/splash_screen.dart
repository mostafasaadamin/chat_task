import 'package:chat/screens/login/login_screen.dart';
import 'package:chat/screens/users/users_screen.dart';
import 'package:flutter/material.dart';

import '../../helper/shared_prefes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    _isLoggedUser();


  }
  void _isLoggedUser() async{
   var isLogged= await Preference.instance.getData("logged")??false;
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => isLogged?UsersListScreen():LoginScreen(), // Replace with your home screen
      ));
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/images/educatly.png', // Path to your logo
            width: 150, // Set width as needed
            height: 150, // Set height as needed
          ),
        ),
      ),
    );
  }
}
