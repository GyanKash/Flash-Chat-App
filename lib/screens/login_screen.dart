import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/add_user.dart';
import 'package:flash_chat/screens/users_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(); // Use a TextEditingController for email
  final TextEditingController passwordController = TextEditingController(); // Use a TextEditingController for password
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: emailController, // Use the controller for email
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  // email = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Email..',
                  hintStyle: hint,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        32.0,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passwordController, // Use the controller for password
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  // password = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Password..',
                  hintStyle: hint,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        32.0,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                      email: emailController.text.trim(), // Use the value from the controller
                      password: passwordController.text, // Use the value from the controller
                    );
                    if (user != null) {
                      Navigator.pushNamed(context, AddUser.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });

                    passwordController.clear();
                    emailController.clear(); // Clear the email field after successful login

                  } catch (error) {
                    print('Sign in Error: $error');
                    Fluttertoast.showToast(
                      msg: "Sign in failed: $error",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                    );
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
                title: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
