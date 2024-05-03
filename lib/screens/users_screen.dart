import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/add_user.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class UsersScreen extends StatefulWidget {
  static String id = 'users';
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<String> _userEmails = [];

  CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('msgs');
  @override
  void initState() {
    super.initState();
    _loadUserEmails();
  }

  Future<void> _loadUserEmails() async {
    _userEmails.clear();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Fetch messages where the current user is the sender
      QuerySnapshot senderSnapshot = await FirebaseFirestore.instance
          .collection('msgs')
          .where('sender', isEqualTo: currentUserId)
          .get();

      // Fetch messages where the current user is the receiver
      QuerySnapshot receiverSnapshot = await FirebaseFirestore.instance
          .collection('msgs')
          .where('receiver', isEqualTo: currentUserId)
          .get();

      // Extract unique user IDs from sender and receiver snapshots
      Set<String> userIds = {};

      senderSnapshot.docs.forEach((doc) {
        userIds.add(doc['receiver']);
      });

      receiverSnapshot.docs.forEach((doc) {
        userIds.add(doc['sender']);
      });

      // Fetch email addresses of users excluding the current user
      for (String userId in userIds) {
        if (userId != currentUserId) {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          String? email = userSnapshot.get('email');
          if (email != null) {
            setState(() {
              _userEmails.add(email);
            });
          }
        }
      }
    } catch (e) {
      print('Error loading user emails: $e');
    }
  }

  Future<void> _addUserEmailIfNotCurrent(
      String currentUserId, String otherUserId) async {
    if (currentUserId != otherUserId && !_userEmails.contains(otherUserId)) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .get();
      String? email = userSnapshot.get('email');
      if (email != null) {
        setState(() {
          _userEmails.add(email);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: _userEmails.isEmpty
          ? const Center(
              child: Text(
                'No Users yet',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: _userEmails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_userEmails[index]),
                  onTap: () {
                    Navigator.pushNamed(context, ChatScreen.id,
                        arguments: {'email': _userEmails[index]});
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        tooltip: 'Add',
        onPressed: () {
          Navigator.pushNamed(context, AddUser.id);
          // Add your functionality here
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
