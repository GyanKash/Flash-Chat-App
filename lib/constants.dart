import 'package:flutter/material.dart';

const sendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const messageTextFieldStyle = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Write a message..',
  hintStyle: TextStyle(
    color: Colors.black54,
  ),
  border: InputBorder.none,
);

const messageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(
      color: Colors.lightBlueAccent,
      width: 2.0,
    ),
  ),
);

const hint = TextStyle(
  color: Colors.black54,
  fontSize: 15.0,
);
