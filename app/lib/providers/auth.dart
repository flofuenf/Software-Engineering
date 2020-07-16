import 'package:flutter/material.dart';

class Auth with ChangeNotifier{
  String userID;
  String accessToken;
  String refreshToken;
  DateTime atExp;
  DateTime rtExp;

  Auth({
    this.userID,
    this.accessToken,
    this.refreshToken,
    this.atExp,
    this.rtExp,
  });

//  bool get isAuth {
//    return token != null;
//  }
//
//  String get token {
//    if (_expiryDate != null &&
//        _expiryDate.isAfter(DateTime.now()) &&
//        _token != null) {
//      return _token;
//    }
//    return null;
//  }
//
//  Auth({
//    this.pw,
//    this.mail,
//    this.commune,
//    this.user,
//  });
//
//  void logout() async {
//    this._token = null;
//    this.mail = null;
//    this.pw = null;
//    this._expiryDate = null;
//    this.commune = null;
//    this.user = null;
//    notifyListeners();
////    final prefs = await SharedPreferences.getInstance();
////    prefs.clear();
//  }
//
////  Future<bool> tryAutoLogin() async {
////    final prefs = await SharedPreferences.getInstance();
////    if (!prefs.containsKey('userData')) {
////      return false;
////    }
////    final prefsData =
////    json.decode(prefs.getString('userData')) as Map<String, Object>;
////    final expiryDate = DateTime.parse(prefsData['expiryDate']);
////
////    if (expiryDate.isBefore(DateTime.now())) {
////      return false;
////    }
////    _token = prefsData['token'];
////    _expiryDate = expiryDate;
////    userName = prefsData['userName'];
////
////    fetchUserInfo();
////    return true;
////  }
//
//  Future<void> login(Auth auth) async {
//    final body = '''{
//      "mail": \"${auth.mail}\",
//      "pw": \"${auth.pw}\"
//    }''';
//
//    try {
//      final res = await GraphHelper.authPost(body);
//
//      _token = "${res['token_type']} ${res['access_token']}";
//      userName = auth['username'];
//      _expiryDate = DateTime.parse(res['expiry']);
//
//      if (_token != null && _expiryDate.isAfter(DateTime.now())) {
//        fetchUserInfo();
//      }
//
//      final prefs = await SharedPreferences.getInstance();
//      final userData = json.encode({
//        'token': _token,
//        'userName': userName,
//        'expiryDate': _expiryDate.toIso8601String(),
//      });
//      prefs.setString('userData', userData);
//    } catch (err) {
//      throw (err);
//    }
//  }
//
//  Future<void> setFavorite(String foodID) async {
//    final body = '''{
//      "uid": \"$userId\",
//      "hasFavorited": [
//      {
//        "uid": \"$foodID\"
//        }
//        ]
//    }''';
//    try {
//      final res = await GraphHelper.postSecure(body, token, "setFavorite");
//
//      if (hasFavorited == null) {
//        hasFavorited = [];
//      }
//      hasFavorited.add(foodID);
//      notifyListeners();
//    } catch (err) {
//      throw (err);
//    }
//  }
//
//  Future<void> deleteFavorite(String foodID) async {
//    final body = '''{
//      "uid": \"$userId\",
//      "hasFavorited": [
//      {
//        "uid": \"$foodID\"
//        }
//        ]
//    }''';
//    try {
//      final res = await GraphHelper.postSecure(body, token, "delFavorite");
//      if (hasFavorited == null) {
//        hasFavorited = [];
//      }
//      hasFavorited.remove(foodID);
//      notifyListeners();
//    } catch (err) {
//      throw (err);
//    }
//  }
//
//  Future<void> setAccount(double account) async {
//    final body = '''
//    {
//      "uid": \"$userId\",
//      "account": $account
//    }
//    ''';
//    try {
//      final res = await GraphHelper.postSecure(body, token, "setAccount");
//      if (res != null) {
//        this.account = account;
//      }
//      notifyListeners();
//    } catch (err) {
//      throw (err);
//    }
//  }
//
//  List<Allergen> setAllergenic(List<dynamic> indexes) {
//    List<Allergen> allergenic = [];
//    indexes.forEach((index) => allergenic.add(Allergen.values[index]));
//    return allergenic;
//  }
//
//  List<String> setFavorites(List<dynamic> indexes) {
//    List<String> favorites = [];
//    indexes.forEach((index) => favorites.add(index['uid']));
//    return favorites;
//  }
//
//  Future<void> createGraphUser(String body) async {
//    try {
//      final res =
//          await GraphHelper.postSecure(body, token, "createUserAccount");
//      if (res == null) {
//        throw ("Something went completely wrong!!");
//      } else {
//        fetchUserInfo();
//      }
//    } catch (err) {
//      throw (err);
//    }
//  }
//
//  void fetchUserInfo() async {
//    final body = '''{
//      "username": \"$userName\"
//    }''';
//
//    try {
//      final res = await GraphHelper.getSecureWithBody(body, _token, "getUser");
//      if (res['uid'].length <= 0) {
//        createGraphUser(body);
//        return;
//      }
//
//      userId = res['uid'];
//      account = res['account'].toDouble();
//      if (res['allergenic'] != null) {
//        allergenic = setAllergenic(res['allergenic']);
//      }
//      isAdmin = res['isAdmin'];
//      if (res['hasFavorited'] != null) {
//        hasFavorited = setFavorites(res['hasFavorited']);
//      }
//      notifyListeners();
//    } catch (err) {
//      throw (err);
//    }
//  }
//
//  Map<String, dynamic> parseJwt(String token) {
//    final parts = token.split('.');
//    if (parts.length != 3) {
//      throw Exception('invalid token');
//    }
//
//    final payload = _decodeBase64(parts[1]);
//    final payloadMap = json.decode(payload);
//    if (payloadMap is! Map<String, dynamic>) {
//      throw Exception('invalid payload');
//    }
//
//    return payloadMap;
//  }
//
//  String _decodeBase64(String str) {
//    String output = str.replaceAll('-', '+').replaceAll('_', '/');
//
//    switch (output.length % 4) {
//      case 0:
//        break;
//      case 2:
//        output += '==';
//        break;
//      case 3:
//        output += '=';
//        break;
//      default:
//        throw Exception('Illegal base64url string!"');
//    }
//    return utf8.decode(base64Url.decode(output));
//  }
}
