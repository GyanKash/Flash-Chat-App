import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/add_user.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/users_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black54
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        UsersScreen.id: (context) => UsersScreen(),
        AddUser.id: (context) => AddUser()
      }
    );
  }
}
