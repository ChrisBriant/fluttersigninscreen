import 'package:flutter/material.dart';

class AuthenticatedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You are Authenticated!'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('You are Autneticated!',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ]
      ),
      
    );
  }
}