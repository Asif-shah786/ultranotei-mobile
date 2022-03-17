import 'dart:convert';
import 'package:http/http.dart';
import 'package:ultranote_infinity/Constants.dart' as Constans;

class ApiService {
  ApiService._internal();

  static final ApiService instance = ApiService._internal();

  Future<dynamic> signup(String firstName, String lastName, String email,String phone, String pass) async {
    var map = new Map<String, dynamic>();
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['mail'] = email;
    map['phone'] = phone;
    map['password'] = pass;
    var response = await post(Uri.parse(Constans.api + "signup"), body: map);
    return response;
  }

  Future<dynamic> login(String email,String pass) async {
    var map = new Map<String, dynamic>();
    map['mail'] = email;
    map['password'] = pass;
    var response = await post(Uri.parse(Constans.api + "signin"), body: map);
    return response;
  }

  Future<dynamic> resetemail(String email) async {
    var map = new Map<String, dynamic>();
    map['mail'] = email;
    var response = await post(Uri.parse(Constans.api + "resetmail"), body: map);
    return response;
  }

  Future<dynamic> resetpass(String newpass,String token) async {
    var map = new Map<String, dynamic>();
    map['password'] = newpass;
    var response = await post(Uri.parse(Constans.api + "newpassword/${token}"), body: map);
    return response;
  }

  Future<dynamic> editprofile(String id,String firstname,String lastname, String mail,String phone,String token) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['firstName'] = firstname;
    map['lastName'] = lastname;
    //map['mail'] = mail;
    map['phone'] = phone;
    var response = await post(Uri.parse(Constans.api + "update_profile/${token}"), body: map);
    return response;
  }

  Future<List> getActivity(String id) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;

    var response = await post(Uri.parse(Constans.api + "user/user_activity"), body: map);

    var extractData = json.decode(response.body);
    return extractData;
  }

}