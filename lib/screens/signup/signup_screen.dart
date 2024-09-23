import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/remote/auth_repository.dart';
import '../../utils/colors.dart';
import 'bloc/signup_bloc.dart';
import 'bloc/signup_event.dart';
import 'bloc/signup_state.dart';
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (context) => SignUpBloc(authRepository: AuthRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Signup'),
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                        : null,

                  ),
                ),
                SizedBox(height: 30),
                _SignUpForm(_image)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _SignUpForm extends StatelessWidget {

  File? image;
  _SignUpForm(this.image);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up successful!')));
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20,),
          ElevatedButton(

            onPressed: () {
              if(image==null) return;
              context.read<SignUpBloc>().add(SignUpSubmitted(
                emailController.text,
                passwordController.text,
                  image
              ));
            },
            child: Text('Sign Up'),
          ),
          BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              if (state is SignUpLoading) {
                return CircularProgressIndicator();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
