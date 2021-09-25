import 'dart:convert';
import 'dart:async';

import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {

  static Future<void> _setToken(token,refresh,expiryDate) async {
    final userData = json.encode({
      'token' : token,
      'refresh' : refresh,
      'expiryDate' : expiryDate!.toIso8601String()
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', userData);
  }

  Future<void> _authenticate(String email, String password) async {
    final url = Uri.parse('https://authapi.chrisbriant.uk/api/account/authenticate/');
    try {
      final res = await http.post(
        url, 
        body: json.encode({
        'email' : email,
        'password' : password,
        }),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(res.body);
      print(responseData);
      if(responseData['success'] != null) {
        if(!responseData['success']) {
          throw HttpException(responseData['message']);
        }
      } else {
        if(responseData['access'] != null) {
          String token = responseData['access'];
          String refresh = responseData['refresh'];
          DateTime? expiryDate = Jwt.getExpiryDate(token);
          await _setToken(token, refresh, expiryDate);
          print(expiryDate);
          print(DateTime.now());
          notifyListeners();
        } else {
          throw HttpException('Something went wrong tying to log on.');
        }
      }
    } catch(err) {
      throw err;
    }
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();

    //prefs.remove('userData');

    if(!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    print(prefs.getString('userData'));
    final DateTime expiryDate = DateTime.parse(extractedUserData['expiryDate'] as String);
    final String refresh = extractedUserData['refresh'] as String; 
    if(expiryDate.isBefore(DateTime.now())) {
      print('Is before');
      //Try refresh token
      final url = Uri.parse('https://authapi.chrisbriant.uk/api/account/refresh/');
      try {
        final res = await http.post(
          url, 
          body: json.encode({
            'refresh': refresh
          }),
          headers: {"Content-Type": "application/json"},
        );
        final responseData = json.decode(res.body);
        if(responseData['access'] != null) {
          //set the access token
          await _setToken(responseData['access'], refresh, expiryDate);
          //notifyListeners();
          return true;
        } else {
          return false;
        }
      } catch(err) {
        print(err);
        return false;
      }
    }
    return true;
  }


  Future<void> signup(String email,String password) async {
    //TODO: Add the proper url and make the register call
    final url = Uri.parse('https://authapi.chrisbriant.uk/api/account/register/');
    try {
      final res = await http.post(
        url, 
        body: json.encode({
          'email' : email,
          'password' : password,
          'passchk' : 'SillyPassword1!'
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = json.decode(res.body);
      print(responseData);
    } catch(err) {
      print(err);
    }
  }

  Future<void> signin(String email,String password) async {
    return _authenticate(email, password);
  }

  Future<void> signout() async {
    //Destroy the token if it exists
    final prefs = await SharedPreferences.getInstance();

    if(prefs.containsKey('userData')) {
      prefs.remove('userData');
    }
    notifyListeners();
  }



}