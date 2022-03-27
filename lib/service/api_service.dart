import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ultranote_infinity/Constants.dart' as Constans;
import 'package:ultranote_infinity/app_theme.dart';

class ApiService {
  ApiService._internal();

  static final ApiService instance = ApiService._internal();

  Future<dynamic> signup(String firstName, String lastName, String email,String phone, String pass) async {
    var map = new Map<String, dynamic>();
    map['firstname'] = firstName;
    map['lastname'] = lastName;
    map['email'] = email;
    map['phoneno'] = phone;
    map['pass'] = pass;
    var response = await post(Uri.parse(Constans.api + "signup"), body: map);
    return response;
  }

  Future<dynamic> login(String email,String pass) async {
    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['password'] = pass;
    var response = await post(Uri.parse(Constans.api + "signin"), body: map);
    return response;
  }

  Future<dynamic> resetemail(String email) async {
    var map = new Map<String, dynamic>();
    map['email'] = email;
    var response = await post(Uri.parse(Constans.api + "resetmail"), body: map);
    return response;
  }

  Future<dynamic> resetpass(String newpass,String token) async {
    var map = new Map<String, dynamic>();
    map['pass'] = newpass;
    var response = await post(Uri.parse(Constans.api + "newpassword/${token}"), body: map);
    return response;
  }

  Future<dynamic> editprofile(String id,String firstname,String lastname, String mail,String phone,String token) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['mail'] = mail;
    map['phone'] = phone;
    var response = await post(Uri.parse(Constans.api + "update_profile"), body: map);
    return response;
  }

  Future<List> getActivity(String id) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;

    var response = await post(Uri.parse(Constans.api + "user/user_activity"), body: map);

    var extractData = json.decode(response.body);
    return extractData;
  }

  Future<dynamic> changeCurrency(String id,String currency) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['currency'] = currency;

    var response = await post(Uri.parse(Constans.api + "user/change_currency"));

    return response;
  }

  Future<dynamic> change2fa(String id,bool isActive) async {
    var map = new Map<String, dynamic>();
    map['_id'] = id;
    map['isActive'] = isActive;

    var response = await post(Uri.parse(Constans.api + "user/change2fa"), body: json.encode(map));


    return response;
  }


  Future<dynamic> otp(var otp,String token) async {
    var map = new Map<String, dynamic>();
    map['code'] = otp;
    var response = await post(Uri.parse(Constans.api + "twofacode/${token}"), body: json.encode(map));
    return response;
  }

  Future<dynamic> mywallet(String id) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    var response = await post(Uri.parse(Constans.api + "wallets/my-wallet"), body: json.encode(map));
    var  extractData= json.decode(response.body);
    return extractData;
  }

  Future<dynamic> transactions(String xuni) async {
    var response = await get(Uri.parse(Constans.api + "wallets/transactions/${xuni}"));
    var  extractData= json.decode(response.body);
    return extractData;
  }

  Future<dynamic> withdraw(String id,String sender, String recipient,String amount,String note,String paymentId) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['sender'] = sender;
    map['recipient'] = recipient;
    map['amount'] = amount;
    map['note'] = note;
    map['paymentid'] = paymentId;
    var response = await post(Uri.parse(Constans.api + "wallets/transactions"), body: json.encode(map));
    return response;
  }

  Future<dynamic> createWallet(String id,String name) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    var response = await post(Uri.parse(Constans.api + "wallets"), body: json.encode(map));
    return response;
  }



}