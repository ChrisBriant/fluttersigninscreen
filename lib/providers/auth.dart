import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;
  late Timer _authTimer;

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
      if(!responseData['success']) {
        throw HttpException(responseData['message']);
      }
      // if (responseData['error'] != null) {
      //   throw HttpException(responseData['error']['message']);
      // }
      // _token = responseData['idToken'];
      // _userId = responseData['localId'];
      // _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      // //_autoLogout();
      // notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   'token' : _token,
      //   'userId' : _userId,
      //   'expiryDate' : _expiryDate.toIso8601String()
      // });
      // prefs.setString('userData', userData);
    } catch(err) {
      throw err;
    }
  }


  Future<void> signup(String email,String password) async {
    return _authenticate(email, password);
  }

  Future<void> signin(String email,String password) async {
    return _authenticate(email, password);
  }



}