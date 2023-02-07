import 'package:flutter/material.dart';

class ShowMessage {

  static show(context, {status=false ,required msg}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(color: Colors.white),),
        backgroundColor: status ? Colors.teal : Colors.redAccent,
      ),
    );
  }

}