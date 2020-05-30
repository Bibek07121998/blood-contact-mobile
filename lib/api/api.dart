import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'http://10.0.2.2:8000/api/account';
  var token;


  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
//    return '?token=$token';
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
//    await _getToken();
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders()
    );
  }
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders()
    );
  }

  _setHeaders() => {
    'content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };

}