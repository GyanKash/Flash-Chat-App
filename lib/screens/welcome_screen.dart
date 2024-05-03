import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/main.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      upperBound: 1.0,
    );

    animation =
        ColorTween(begin: Colors.red, end: Colors.white).animate(controller);

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText('Flash Chat',
                      textStyle: const TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ))
                ])
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              colour: Colors.lightBlue,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              title: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
