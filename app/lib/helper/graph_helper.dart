import 'dart:convert';

import 'package:http/http.dart' as http;

const address = "http://localhost:8000";

class GraphHelper {
  //this will be moved because of O-Auth
//  static Future<Map<dynamic, dynamic>> authPost(String body) async {
//    final url = "$address/auth";
//    try {
//      final request = new http.Request("POST", Uri.parse(url));
//      request.body = body;
//      request.headers['Content-Type'] = 'application/json';
//      final response = await http.Client().send(request);
//      String responseData = await response.stream.bytesToString();
//      if (jsonDecode(responseData)['success'] == true) {
//        return jsonDecode(responseData)['data'];
//      }
//      throw (jsonDecode(responseData)['error']);
//    } on http.ClientException {
//      throw ("Please check your internet connection!");
//    } catch (err) {
//      throw (err);
//    }
//  }
//
//  //returns a Map
//  static Future<Map<dynamic, dynamic>> getSecureWithBody(
//      String body, token, urlSegment) async {
//    final url = "$address/api/$urlSegment";
//    try {
//      final request = new http.Request("POST", Uri.parse(url));
//      request.body = body;
//      request.headers['Content-Type'] = 'application/json';
//      request.headers['Authorization'] = token;
//      final response = await http.Client().send(request);
//      String responseData = await response.stream.bytesToString();
//      if (jsonDecode(responseData)['success'] == true) {
//        return jsonDecode(responseData)['data'];
//      }
//      throw (jsonDecode(responseData)['error']);
//    } on http.ClientException {
//      throw ("Please check your internet connection!");
//    } catch (err) {
//      throw (err);
//    }
//  }

  //returns a List
//  static Future<List<dynamic>> getListSecureWithBody(
//      String body, token, urlSegment) async {
//    final url = "$address/api/$urlSegment";
//    try {
//      final request = new http.Request("POST", Uri.parse(url));
//      request.body = body;
//      request.headers['Content-Type'] = 'application/json';
////      request.headers['Authorization'] = token;
//      final response = await http.Client().send(request);
//      String responseData = await response.stream.bytesToString();
//      if (jsonDecode(responseData)['success'] == true) {
//        return jsonDecode(responseData)['data'];
//      }
//      throw (jsonDecode(responseData)['error']);
//    } on http.ClientException {
//      throw ("Please check your internet connection!");
//    } catch (err) {
//      throw (err);
//    }
//  }

  //standard dGo function
  static Future<dynamic> postSecure(String body, urlSegment) async {
    final url = "$address/$urlSegment";
    try {
      final request = new http.Request("POST", Uri.parse(url));
      request.body = body;
      request.headers['Content-Type'] = 'application/json';
//      request.headers['Authorization'] = token;
      final response = await http.Client().send(request);
      String responseData = await response.stream.bytesToString();
      if (jsonDecode(responseData)['success'] == true) {
        return jsonDecode(responseData)['result'];
      }
      throw (jsonDecode(responseData)['error']);
    } on http.ClientException {
      throw ("Please check your internet connection!");
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  //use this only if you just want to fetch data
  static Future<List<dynamic>> getSecure(String body, String urlSegment) async {
    final url = "$address/$urlSegment";
    try {
      final request = new http.Request("GET", Uri.parse(url));
      request.body = body;
      print(request.body);
      request.headers['Content-Type'] = 'application/json';
//      request.headers['Authorization'] = token;
      final response = await http.Client().send(request);
      String responseData = await response.stream.bytesToString();
      print(responseData);
      if (jsonDecode(responseData)['success'] == true) {
        print("true");
        return jsonDecode(responseData)['result'];
      }
      throw (jsonDecode(responseData)['error']);
    } on http.ClientException {
      throw ("Please check your internet connection!");
    } catch (err) {
      throw (err);
    }
  }
}
