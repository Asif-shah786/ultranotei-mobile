import 'dart:convert';
import 'package:http/http.dart';
import 'package:ultranote_infinity/Constants.dart' as Constans;
import 'package:ultranote_infinity/screen/message/get_msglist_model.dart';

class ApiService {
  ApiService._internal();

  static final ApiService instance = ApiService._internal();

  Future<dynamic> signup(String firstName, String lastName, String email,
      String phone, String pass) async {
    var map = new Map<String, dynamic>();
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['mail'] = email;
    map['phone'] = phone;
    map['password'] = pass;
    var response = await post(Uri.parse(Constans.api + "signup"), body: map);
    return response;
  }

<<<<<<< HEAD
  Future<dynamic> login(String email, String pass) async {
=======
  Future<dynamic> login(String email,String pass) async {

    print('Entert to $email');
    print('Entert to $pass');
>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9
    var map = new Map<String, dynamic>();
    map['mail'] = email;
    map['password'] = pass;

<<<<<<< HEAD
    var response = await post(Uri.parse(Constans.api + "signin"), body: map);

=======
    print('request object');
    print(map);
    var response = await post(Uri.parse(Constans.api + "signin"), body: map);
    print('server response object');
    print('${response.statusCode}');
    print('${response.body}');
>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9
    return response;
  }

  Future<dynamic> resetemail(String email) async {
    var map = new Map<String, dynamic>();
    map['mail'] = email;
    var response = await post(Uri.parse(Constans.api + "resetmail"), body: map);
    return response;
  }

  Future<dynamic> resetpass(String newpass, String token) async {
    var map = new Map<String, dynamic>();
    map['password'] = newpass;
<<<<<<< HEAD
    var response =
        await post(Uri.parse(Constans.api + "newpassword/${token}"), body: map);
=======
    var response = await post(Uri.parse(Constans.api + "newpassword/${token}"), body: map);
>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9
    return response;
  }

  Future<dynamic> editprofile(String id, String firstname, String lastname,
      String mail, String phone, String token) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['mail'] = mail;
    map['phone'] = phone;
<<<<<<< HEAD
    var response = await post(
        Uri.parse(Constans.api + "update_profile/${token}"),
        body: map);
=======
    var response = await post(Uri.parse(Constans.api + "update_profile/${token}"), body: map);
>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9
    //var response = await post(Uri.parse(Constans.api + "update_profile"), body: map);
    return response;
  }

  Future<List> getActivity(String id) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;

    var response =
        await post(Uri.parse(Constans.api + "user/user_activity"), body: map);

    var extractData = json.decode(response.body);
    return extractData;
  }

  Future<dynamic> changeCurrency(String id, String currency) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['currency'] = currency;
<<<<<<< HEAD
    var response = await post(Uri.parse(Constans.api + "user/change_currency"),
        body: json.encode(map), headers: {"content-type": "application/json"});
=======
    var response = await post(Uri.parse(Constans.api + "user/change_currency"), body: json.encode(map),headers:{"content-type":"application/json"});

>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9

    return response;
  }

  Future<dynamic> change2fa(String id, bool isActive) async {
    var map = new Map<String, dynamic>();
    map['_id'] = id;
    map['isActive'] = isActive;
<<<<<<< HEAD
    var response = await post(Uri.parse(Constans.api + "user/change2fa"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    // var response = await post(Uri.parse(Constans.api + "user/change2fa"), body: json.encode(map));
=======
    var response = await post(Uri.parse(Constans.api + "user/change2fa"), body: json.encode(map),headers:{"content-type":"application/json"});
    // var response = await post(Uri.parse(Constans.api + "user/change2fa"), body: json.encode(map));

>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9

    return response;
  }

  Future<dynamic> otp(var otp, String token) async {
    var map = new Map<String, dynamic>();
    map['code'] = otp;
    var response = await post(Uri.parse(Constans.api + "twofacode/${token}"),
        body: json.encode(map));
    return response;
  }

  Future<dynamic> mywallet(String id) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
<<<<<<< HEAD
    var response = await post(Uri.parse(Constans.api + "wallets/my-wallet"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    var extractData = json.decode(response.body);
    print('mywallet: ${response.body}');
=======
    var response = await post(Uri.parse(Constans.api + "wallets/my-wallet"), body: json.encode(map),headers:{"content-type":"application/json"});
    var  extractData= json.decode(response.body);
>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9
    return extractData;
  }

  Future<dynamic> transactions(String xuni) async {
    var response =
        await get(Uri.parse(Constans.api + "wallets/transactions/${xuni}"));
    var extractData = json.decode(response.body);
    return extractData;
  }

<<<<<<< HEAD
  Future<dynamic> withdraw(String id, String sender, String recipient,
      String amount, String note, String paymentId) async {
=======
  Future<dynamic> withdraw(String id,String sender, String recipient,String amount,String note,String paymentId) async {


>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['sender'] = sender;
    map['recipient'] = recipient;
    map['paymentId'] = paymentId;
    map['amount'] = amount;
    map['note'] = note;
<<<<<<< HEAD
    var response = await post(Uri.parse(Constans.api + "wallets/transactions"),
        body: json.encode(map), headers: {"content-type": "application/json"});
=======
    var response = await post(Uri.parse(Constans.api + "wallets/transactions"), body: json.encode(map),headers:{"content-type":"application/json"});
>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9

    return response;
  }

  Future<dynamic> createWallet(String id, String name) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
<<<<<<< HEAD
    var response = await post(Uri.parse(Constans.api + "wallets"),
        body: json.encode(map), headers: {"content-type": "application/json"});
=======
    var response = await post(Uri.parse(Constans.api + "wallets"), body: json.encode(map),headers:{"content-type":"application/json"});
>>>>>>> b04b0a7228ed91b20a4524134e6a8444ecc392b9
    print(response.statusCode);
    return response;
  }

  Future<dynamic> SendMessage(
    String id,
  ) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;

    var response = await post(Uri.parse(Constans.api + "wallets/messages"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    print(response.statusCode);
    return response.body;
  }

  Future<GetMsgList> getMessages(
    String id,
  ) async {
    // List<GetMsgList>? allMSgsList;

    var map = new Map<String, dynamic>();
    map['id'] = id;
    var response = await post(Uri.parse(Constans.api + "wallets/messages"),
        body: json.encode(map), headers: {"content-type": "application/json"});

    print(response.body);
    var model = GetMsgList.fromJson(jsonDecode(response.body));
    print('length of list ${model.msgList![0].message}');
    print('length of list ${model.msgList![0].headers}');

    print('----------');

    print(response.statusCode);
    return model;
  }

  Future<dynamic> addAddress(String id, String label, String address) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['label'] = label;
    map['address'] = address;
    var response = await post(Uri.parse(Constans.api + "user/add_contact"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    print(response.statusCode);
    return response;
  }

  Future<dynamic> deleteAddress(String id, int deleteRow) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['deleteRow'] = deleteRow;
    print(map);
    var response = await post(Uri.parse(Constans.api + "user/delete_contact"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    print(response.statusCode);
    return response;
  }

  Future<dynamic> getAttachment(String id, int deleteRow) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['deleteRow'] = deleteRow;
    print(map);
    var response = await post(Uri.parse(Constans.api + "user/delete_contact"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    print(response.statusCode);
    return response;
  }
}
