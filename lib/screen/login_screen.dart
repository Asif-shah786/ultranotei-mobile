import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/otp_screen.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/input_auth_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';

import '../app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();
  bool _isInAsyncCall = false;

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
            toolbarHeight: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icon/ultranote_icon.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Text("LOGIN",
                    style: CustomAppTheme.startText,),
                  SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Email",emailController,TextInputType.emailAddress,false),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Password",passController,TextInputType.visiblePassword,true),
                  ),
                  SizedBox(height: 10,),
                  InkWell(onTap:(){forgotPass();},child: Text("Forgot your password?",style: CustomAppTheme.smallBlueText,textAlign: TextAlign.center,)),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: LoginBtn('LOGIN', (){loginPress();}, CustomAppTheme.btnWhiteText),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have account? ",style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                      InkWell(
                        onTap: (){
                          signup();
                        },
                          child: Text("Sign up",style: CustomAppTheme.smallBlueBoldText,textAlign: TextAlign.center,)),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginPress(){
    print('login');


    String email=emailController.text.trim();
    String pass=passController.text.trim();

    if(email.isEmpty){
      showSnackBar(context,"Enter email");
      return;
    }

    if(pass.isEmpty){
      showSnackBar(context,"Enter pass");
      return;
    }

    setState(() {
      _isInAsyncCall=true;
    });
    ApiService.instance.login(email, pass).then((value) {

      var extractData = json.decode(value.body);
      if(value.statusCode==200){

        print('name  ${extractData.toString()}');

        if(extractData['user']['two_fact_auth']==true){
          showSnackBar(context,extractData['message']);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(pass,extractData['token'].toString()),
              ));
        }else{
          CurrentUser currentUser = new CurrentUser(extractData['user']['firstName'].toString(),extractData['user']['lastName'].toString(),extractData['user']['mail'].toString(),extractData['user']['phone'].toString(),extractData['user']['two_fact_auth'].toString(),extractData['user']['isActive'].toString(),extractData['user']['isWalletCreated'].toString(),extractData['user']['currency'].toString(),extractData['user']['id'].toString(),extractData['token'].toString(),pass);
          UserLocalStore userLocalStore = new UserLocalStore();
          userLocalStore.storeUserData(currentUser);
          showSnackBar(context,extractData['message']);
          Navigator.of(context).pushNamedAndRemoveUntil('/homescreen', (Route<dynamic> route) => false);
        }

      }else{
        showSnackBar(context,extractData['message']);
      }

      setState(() {
        _isInAsyncCall=false;
      });


    });
  }

  signup(){
    print('signup');
    Navigator.pushNamed(context, '/signupscreen');
  }

  forgotPass(){
    print('forgotPass');
    Navigator.pushNamed(context, '/forgotpassscreen');
  }
}
