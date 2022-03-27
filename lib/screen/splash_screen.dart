import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    new Future.delayed(const Duration(milliseconds: 100), () {

      UserLocalStore userLocalStore = new UserLocalStore();
      Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
      cUSer.then((value) {
        if (value.id.toString() == 'null' || value.id.toString().isEmpty) {
          Navigator.pushReplacementNamed(context, '/loginsignupscreen');
        }else{
          loginApi(value.email,value.pass);
        }
      });
    });

    super.initState();
  }


  loginApi(String email, String pass){

    ApiService.instance.login(email, pass).then((value) {
      var extractData = json.decode(value.body);
      if(value.statusCode==200){
          CurrentUser currentUser = new CurrentUser(extractData['user']['firstName'].toString(),extractData['user']['lastName'].toString(),extractData['user']['mail'].toString(),extractData['user']['phone'].toString(),extractData['user']['two_fact_auth'].toString(),extractData['user']['isActive'].toString(),extractData['user']['isWalletCreated'].toString(),extractData['user']['currency'].toString(),extractData['user']['id'].toString(),extractData['token'].toString(),pass);
          UserLocalStore userLocalStore = new UserLocalStore();
          userLocalStore.storeUserData(currentUser);
          Navigator.of(context).pushNamedAndRemoveUntil('/homescreen', (Route<dynamic> route) => false);
      }else{
        signout();
        Navigator.pushReplacementNamed(context, '/loginsignupscreen');
      }



    });

  }


  signout(){
    print('log out');
    UserLocalStore userLocalStore = new UserLocalStore();
    userLocalStore.clearUserData();
    showSnackBar(context,"Please login again");
    Navigator.pushReplacementNamed(context, '/loginsignupscreen');
  }
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: CustomAppTheme.black_bar
    ));

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/back/startpage_back.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top:125),
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icon/ultranote_icon.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
