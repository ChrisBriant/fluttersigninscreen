import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Column(children: <Widget>[
          Text('Sign up for a new account:'),
          Form(
          child: Column(children: [

            ],)
          ),
      ],),
    );

  }
}