import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/input_auth_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';
import 'package:ultranote_infinity/service/api_service.dart';

import '../app_theme.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isInAsyncCall = false;
  String id = '';
  bool isActive = false;

  String currency = '';
  late CurrentUser cvalue;
  List currencyList = ['usd', 'btc'];
  bool is2FaEnable = false;
  String qrImage = '';
  TextEditingController CodeController = TextEditingController();
  getUser() {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((value) {
      setState(() {
        cvalue = value;

        id = value.id;
        isActive = value.otp == 'true' ? true : false;
        is2FaEnable = value.twoFA == 'true' ? true : false;
        currency = value.currency;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/back/loginpage_back.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: CustomAppTheme.black_bar,
            elevation: 0,
            centerTitle: true,
            title: Text('Settings', style: CustomAppTheme.actionBarText),
          ),
          body: Container(
            height: height,
            width: width,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Mail Factor Authentication",
                      style: CustomAppTheme.settingText,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Enable your OTP ont time password.You will receive codes to your email address.",
                      style: CustomAppTheme.smallBlueBoldText,
                    ),
                    SizedBox(
                      width: 100,
                      // height: 40,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                            value: isActive,
                            onChanged: (value) {
                              setState(() {
                                isActive = value;
                              });
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: LoginBtn('SAVE', () {
                        submit2fa();
                      }, CustomAppTheme.btnWhiteText),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    qrImage == ''
                        ? SizedBox(
                      height: height * 0.3,
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "2FA Factor Authentication",
                            style: CustomAppTheme.settingText,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Authenticator App",
                            style: CustomAppTheme.smallWhiteBoldText,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Use the Authenticator app to get verifcation codes, You can use Google Authenticator or any similar apps.",
                            style: CustomAppTheme.smallBlueBoldText,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          is2FaEnable == true
                              ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50.0),
                            child: LoginBtn('Disable', () {
                              deactivateAuthenticator(false);
                            }, CustomAppTheme.btnWhiteText),
                          )
                              : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50.0),
                            child: LoginBtn('Enable', () {
                              activateAuthenticator(true);
                            }, CustomAppTheme.btnWhiteText),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      height: height * 0.5,
                      width: width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: height * 0.2,
                            width: width * 0.5,
                            child: Image.memory(Base64Decoder().convert(
                                qrImage.replaceAll(
                                    "data:image/png;base64,", ""))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50.0),
                            child: InputAuthField("CODE", CodeController,
                                TextInputType.number, false),
                          ),
                          Container(
                            height: height * 0.1,
                            width: width,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (CodeController.text.isNotEmpty) {
                                      verifyAuthenticator();
                                    } else {
                                      print("fill data");
                                    }
                                  },
                                  child: Container(
                                    height: height * 0.07,
                                    width: width * 0.35,
                                    decoration: BoxDecoration(
                                        color: CustomAppTheme.black_login,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "CONFIRM",
                                      style:
                                      TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      qrImage = '';
                                    });
                                  },
                                  child: Container(
                                    height: height * 0.07,
                                    width: width * 0.35,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Text("CANCEL"),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Select Currency ",
                      style: CustomAppTheme.settingText,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 'usd',
                          groupValue: currency,
                          onChanged: (value) {
                            setState(() {
                              currency = value.toString();
                            });
                          },
                        ),
                        Text(
                          "USD",
                          style: CustomAppTheme.smallWhiteText,
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Radio(
                          value: 'btc',
                          groupValue: currency,
                          onChanged: (value) {
                            setState(() {
                              currency = value.toString();
                            });
                          },
                        ),
                        Text(
                          "BTC",
                          style: CustomAppTheme.smallWhiteText,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: LoginBtn('SAVE', () {
                        submitCurrency();
                      }, CustomAppTheme.btnWhiteText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  submit2fa() {
    setState(() {
      _isInAsyncCall = true;
    });
    ApiService.instance.change2fa(id, isActive).then((value) {
      print(value.body.toString());
      var extractData = json.decode(value.body);
      if (value.statusCode == 200) {
        CurrentUser currentUser = cvalue;
        currentUser.otp = isActive;
        UserLocalStore userLocalStore = new UserLocalStore();
        userLocalStore.storeUserData(currentUser);
        showSnackBar(context, extractData['message']);
      } else {
        showSnackBar(context, extractData['message']);
      }

      setState(() {
        _isInAsyncCall = false;
      });
    });
  }

  activateAuthenticator(bool v) {
    setState(() {
      _isInAsyncCall = true;
    });
    ApiService.instance.changeAuthenticator(id, v).then((value) {
      print(value.body.toString());
      var extractData = json.decode(value.body);
      if (value.statusCode == 200) {
        setState(() {
          qrImage = extractData['value']['qrCode'].toString();
        });

        // showSnackBar(context, extractData['message']);
      } else {
        //showSnackBar(context, extractData['message']);
      }

      setState(() {
        _isInAsyncCall = false;
      });
    });
  }

  deactivateAuthenticator(bool v) {
    setState(() {
      _isInAsyncCall = true;
    });
    ApiService.instance.changeAuthenticator(id, v).then((value) {
      print(value.body.toString());
      var extractData = json.decode(value.body);
      if (value.statusCode == 200) {
        CurrentUser currentUser = cvalue;
        currentUser.twoFA = v;
        UserLocalStore userLocalStore = new UserLocalStore();
        userLocalStore.storeUserData(currentUser);
        setState(() {
          is2FaEnable = v;
        });
        // showSnackBar(context, extractData['message']);
      } else {
        // showSnackBar(context, extractData['message']);
      }

      setState(() {
        _isInAsyncCall = false;
      });
    });
  }

  verifyAuthenticator() {
    setState(() {
      _isInAsyncCall = true;
    });
    ApiService.instance
        .verifyAuthenticator(id, CodeController.text)
        .then((value) {
      print(value.body.toString());
      var extractData = json.decode(value.body);
      if (value.statusCode == 200) {
        CurrentUser currentUser = cvalue;
        currentUser.twoFA = true;
        UserLocalStore userLocalStore = new UserLocalStore();
        userLocalStore.storeUserData(currentUser);
        print(extractData.toString());
        setState(() {
          is2FaEnable = true;
          qrImage = '';
        });

        // showSnackBar(context, extractData['message']);
      } else {
        //showSnackBar(context, extractData['message']);
      }

      setState(() {
        _isInAsyncCall = false;
      });
    });
  }

  submitCurrency() {
    setState(() {
      _isInAsyncCall = true;
    });
    ApiService.instance.changeCurrency(id, currency).then((value) {
      print(value.body.toString());
      var extractData = json.decode(value.body);
      if (value.statusCode == 200) {
        CurrentUser currentUser = cvalue;
        currentUser.currency = currency.toString();
        UserLocalStore userLocalStore = new UserLocalStore();
        userLocalStore.storeUserData(currentUser);
        showSnackBar(context, extractData['message']);
      } else {
        showSnackBar(context, extractData['message']);
      }

      setState(() {
        _isInAsyncCall = false;
      });
    });
  }
}
