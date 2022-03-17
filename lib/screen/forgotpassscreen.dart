import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/input_auth_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';

import '../app_theme.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {

  TextEditingController emailController=TextEditingController();
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
                  Text("RESTORE PASSWORD",
                    style: CustomAppTheme.startText,),
                  SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Email",emailController,TextInputType.emailAddress,false),
                  ),

                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text("You will receive email with password reset link.",style: CustomAppTheme.smallBlueText,textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 60,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: LoginBtn('SEND INTRUCTIONS', (){sendInstruction();}, CustomAppTheme.btnWhiteText),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                      InkWell(
                          onTap: (){
                            loginPress();
                          },
                          child: Text("Login",style: CustomAppTheme.smallBlueBoldText,textAlign: TextAlign.center,)),
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


  sendInstruction(){

    String email=emailController.text.trim();

    if(email.isEmpty){
      showSnackBar(context,"Enter email");
      return;
    }


    setState(() {
      _isInAsyncCall=true;
    });
    ApiService.instance.resetemail(email).then((value) {

      var extractData = json.decode(value.body);
      if(value.statusCode==200){

        showSnackBar(context,extractData['message']);

      }else{
        showSnackBar(context,extractData['message']);
      }

      setState(() {
        _isInAsyncCall=false;
      });


    });
  }

  loginPress(){
    print('login ');
    Navigator.of(context).pop();
  }
}
