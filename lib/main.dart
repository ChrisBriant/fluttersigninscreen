import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/authenticated_screen.dart';
import './screens/signup_complete_screen.dart';
import './screens/wait_screen.dart';


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
            ? WaitScreen()
            : authed.data == true ? AuthenticatedScreen() : AuthScreen()
          ),
          routes: {
            SignupCompleteScreen.routeName : (ctx) => SignupCompleteScreen(),
            AuthScreen.routeName : (ctx) => AuthScreen(),
          }, 
        ),
      ),
    );
  }
}
