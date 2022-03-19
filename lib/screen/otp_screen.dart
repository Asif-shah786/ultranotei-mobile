import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/input_auth_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../app_theme.dart';

class OTPScreen extends StatefulWidget {

  String pass;
  String token;


  OTPScreen(this.pass,this.token);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  bool _isInAsyncCall = false;
  int otp=0;

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
                  Text("Code Verification",
                    style: CustomAppTheme.startText,),
                  SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text("Enter the verification code which was sent to your email.",
                      style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 30,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: PinCodeTextField(
                      pinTheme:PinTheme.defaults(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        shape: PinCodeFieldShape.box
                      ),
                      keyboardType:TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textStyle: TextStyle(color: Colors.white),
                      mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      animationDuration: Duration(milliseconds: 300),
                      //errorAnimationController: errorController, // Pass it here
                      onChanged: (value) {
                        setState(() {
                          otp=int.parse(value);
                        });
                      }, appContext: context,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: LoginBtn('SUBMIT', (){submitPress();}, CustomAppTheme.btnWhiteText),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submitPress(){
    print('login');



    if(otp<1000){
      showSnackBar(context,"Enter otp");
      return;
    }

    print(widget.token);


    setState(() {
      _isInAsyncCall=true;
    });

    ApiService.instance.otp(otp, widget.token).then((value) {


      var extractData = json.decode(value.body);
      if(value.statusCode==200){

        print('name  ${extractData.toString()}');
        CurrentUser currentUser = new CurrentUser(extractData['user']['firstName'].toString(),extractData['user']['lastName'].toString(),extractData['user']['mail'].toString(),extractData['user']['phone'].toString(),extractData['user']['two_fact_auth'].toString(),extractData['user']['isActive'].toString(),extractData['user']['isWalletCreated'].toString(),extractData['user']['currency'].toString(),extractData['user']['id'].toString(),extractData['token'].toString(),widget.pass);
        UserLocalStore userLocalStore = new UserLocalStore();
        userLocalStore.storeUserData(currentUser);
        showSnackBar(context,extractData['message']);
        Navigator.of(context).pushNamedAndRemoveUntil('/homescreen', (Route<dynamic> route) => false);
      }else{
        showSnackBar(context,extractData['message']);
      }

      setState(() {
        _isInAsyncCall=false;
      });


    });
  }
}
