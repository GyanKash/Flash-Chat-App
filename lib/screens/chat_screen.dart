import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String receiverEmail;
  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print('Logged in user: ${loggedInUser.email}');
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    receiverEmail = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            icon: const Icon(Icons.close),
          ),
        ],
        title: Text(receiverEmail),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            myMsgsWidget(),
            Container(
              decoration: messageContainerDecoration,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      decoration: messageTextFieldStyle,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      sendMessage();
                    },
                    child: const Text(
                      'Send',
                      style: sendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    try {
      _firestore.collection('msgs').add({
        'text': messageText,
        'sender': loggedInUser.email,
        'receiver': receiverEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });
      msgTextController.clear();
    } catch (e) {
      print('Error sending message: $e');
      // Optionally, show an error message to the user
    }
  }

  Widget myMsgsWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('msgs')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const CircularProgressIndicator();
        }
        final msgs = snapshot.data!.docs;

        List<Widget> msgBubbles = [];
        for (var msg in msgs) {
          final msgText = msg['text'];
          final msgSender = msg['sender'];

          final isMe = loggedInUser.email == msgSender;

          final msgBubble = MsgBubble(
            sender: msgSender,
            text: msgText,
            isMe: isMe,
            timestamp: DateTime.timestamp().toString(),
          );
          msgBubbles.add(msgBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: msgBubbles,
          ),
        );
      },
    );
  }
}

class MsgBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String timestamp;

  const MsgBubble(
      {required this.sender,
        required this.text,
        required this.isMe,
        required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            timestamp,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )
                : const BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.greenAccent,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
