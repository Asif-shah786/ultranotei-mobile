import 'dart:convert';
import 'package:http/http.dart';
import 'package:ultranote_infinity/Constants.dart' as Constans;
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/message/get_msglist_model.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';

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

  Future<dynamic> login(String email, String pass) async {
    var map = new Map<String, dynamic>();
    map['mail'] = email;
    map['password'] = pass;

    print('request object');
    print(map);
    var response = await post(Uri.parse(Constans.api + "signin"), body: map);
    print('server response object');
    print('${response.body}');
    print('${response}');
    return response;
  }

  Future<dynamic> resetemail(String email) async {
    var map = new Map<String, dynamic>();
    map['mail'] = email;
    var response = await post(Uri.parse(Constans.api + "resetmail"), body: map);
    return response;
  }

  Future<dynamic> postDeposit(
      String id, String address, double amount, int term) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['sourceAddress'] = address;
    map['amount'] = amount;
    map['term'] = term;
    var response = await post(Uri.parse(Constans.api + "wallets/deposit_stake"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    var extractData = json.decode(response.body);

    return extractData;
  }

  Future<dynamic> resetpass(String newpass, String token) async {
    var map = new Map<String, dynamic>();
    map['password'] = newpass;
    var response =
        await post(Uri.parse(Constans.api + "newpassword/${token}"), body: map);
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
    var response = await post(
        Uri.parse(Constans.api + "update_profile/${token}"),
        body: map);
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
    var response = await post(Uri.parse(Constans.api + "user/change_currency"),
        body: json.encode(map), headers: {"content-type": "application/json"});

    return response;
  }

  Future<dynamic> change2fa(String id, bool isActive) async {
    var map = new Map<String, dynamic>();
    map['_id'] = id;
    map['isActive'] = isActive;
    var response = await post(Uri.parse(Constans.api + "user/change2fa"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    // var response = await post(Uri.parse(Constans.api + "user/change2fa"), body: json.encode(map));

    return response;
  }

  Future<dynamic> changeAuthenticator(String id, bool isActive) async {
    var map = new Map<String, dynamic>();
    map['_id'] = id;
    map['state'] = isActive;
    var response = await post(Uri.parse(Constans.api + "user/auth2FATMP"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    // var response = await post(Uri.parse(Constans.api + "user/change2fa"), body: json.encode(map));

    return response;
  }

  Future<dynamic> verifyAuthenticator(String id, String token) async {
    var map = new Map<String, dynamic>();
    map['_id'] = id;
    map['token'] = token;
    var response = await post(Uri.parse(Constans.api + "user/auth2FAConfirm"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    // var response = await post(Uri.parse(Constans.api + "user/change2fa"), body: json.encode(map));

    return response;
  }

  Future<dynamic> otp(var otp, String token) async {
    print("--------");
    print(token);
    print(otp);
    var map = new Map<String, dynamic>();
    map['code'] = otp;
    var response = await post(Uri.parse(Constans.api + "otp/${token}"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    return response;
  }

  Future<dynamic> verifyby2FA(var otp, String token) async {
    print("--------");
    print(token);
    print(otp);
    var map = new Map<String, dynamic>();
    map['code'] = otp;
    var response = await post(Uri.parse(Constans.api + "twofacode/${token}"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    return response;
  }

  Future<dynamic> mywallet(String id) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    var response = await post(Uri.parse(Constans.api + "wallets/my-wallet"),
        body: json.encode(map), headers: {"content-type": "application/json"});
    var extractData = json.decode(response.body);
    return extractData;
  }

  Future<dynamic> transactions(String xuni) async {
    var response =
        await get(Uri.parse(Constans.api + "wallets/transactions/${xuni}"));
    var extractData = json.decode(response.body);
    return extractData;
  }

  Future<dynamic> deposits(String xuni) async {
    var response =
        await get(Uri.parse(Constans.api + "wallets/my_deposits/${xuni}"));
    var extractData = json.decode(response.body);
    return extractData;
  }

  Future<dynamic> withdraw(String id, String sender, String recipient,
      String amount, String note, String paymentId) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['sender'] = sender;
    map['recipient'] = recipient;
    map['paymentId'] = paymentId;
    map['amount'] = amount;
    map['note'] = note;
    var response = await post(Uri.parse(Constans.api + "wallets/transactions"),
        body: json.encode(map), headers: {"content-type": "application/json"});

    return response;
  }

  Future<dynamic> createWallet(String id, String name) async {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    var response = await post(Uri.parse(Constans.api + "wallets"),
        body: json.encode(map), headers: {"content-type": "application/json"});
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

  Future<dynamic> getChatMessages() async {
    UserLocalStore userLocalStore = new UserLocalStore();
    CurrentUser cUSer = await userLocalStore.getLoggedInUser();

    var response = await get(Uri.parse(Constans.api + "wallets/getmessages"),
        headers: {"Authorization": "Bearer ${cUSer.token}"});
    var extractData = json.decode(response.body);
    return extractData;
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

  Future<dynamic> downlodAttachment(
      var transactionId, var attachment, encryptionKey) async {
    var map = new Map<String, dynamic>();
    map['attachment'] = attachment;
    map['encryptionKey'] = encryptionKey;
    map['transactionId'] = transactionId;
    var response = await post(Uri.parse(Constans.api + "/wallets/attachment"),
        body: json.encode(map),
        headers: {
          "content-type": "application/json",
        });

    return response.bodyBytes;
  }
}
