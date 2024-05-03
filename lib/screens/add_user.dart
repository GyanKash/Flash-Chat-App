import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart'; // Import the ChatScreen
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddUser extends StatefulWidget {

  static String id = 'add';

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  String _enteredEmail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: 'Enter email you wanna talk to..',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onSaved: (value) => _enteredEmail = value!,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  bool isRegistered = await checkEmail(_enteredEmail);
                  if (isRegistered) {
                    Navigator.pushNamed(context, ChatScreen.id, arguments: _enteredEmail);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No such user exists'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkEmail(String email) async {
    try {
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      print('true');
      return true;
    } catch (e) {
      print('false');
      return false;
    }
  }
}