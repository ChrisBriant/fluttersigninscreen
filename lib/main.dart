import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth(),)
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth,_) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            primaryTextTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white) 
            )
          
          ),
          home: FutureBuilder(
            future: auth.isAuthenticated(),
            builder: (ctx,authed) =>  authed.connectionState == ConnectionState.waiting
            ? Text('Waiting')
            : authed.data == true ? Text('You are authenticated ${authed.data}') : AuthScreen()
          ) 
        ),
      ),
    );
  }
}
