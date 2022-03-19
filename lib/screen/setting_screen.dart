import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
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
  List currencyList=['usd','btc'];

getUser() {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((value) {
      setState(() {
        cvalue = value;

        id = value.id;
        isActive = value.twoFactorAuth == 'true' ? true : false;
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

  @override
  Widget build(BuildContext context) {
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
          body: SingleChildScrollView(
              child: Column(
            children: [

              SizedBox(
                height: 40,
              ),
              Text(
                "2 Factor Authentication",
                style: CustomAppTheme.settingText,
              ),

              SizedBox(
                width: 100,
               // height: 40,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(value: isActive, onChanged: (value) {
                    setState(() {
                      isActive=value;
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
                        currency=value.toString();

                      });
                    },
                  ),
                  Text("USD",style: CustomAppTheme.smallWhiteText,),
                  SizedBox(
                    width: 40,
                  ),
                  Radio(
                    value: 'btc',
                    groupValue: currency,
                    onChanged: (value) {
                      setState(() {
                        currency=value.toString();

                      });
                    },
                  ),

                  Text("BTC",style: CustomAppTheme.smallWhiteText,),



              ],),
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
          )),
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
        currentUser.twoFactorAuth = isActive.toString();
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
