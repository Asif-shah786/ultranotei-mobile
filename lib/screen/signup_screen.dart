import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/input_auth_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';

import '../app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController mobileController=TextEditingController();
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
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icon/ultranote_icon.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("SIGN UP",
                    style: CustomAppTheme.startText,),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Firstname",firstNameController,TextInputType.name,false),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Lastname",lastNameController,TextInputType.name,false),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Email",emailController,TextInputType.emailAddress,false),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Mobile",mobileController,TextInputType.number,false),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Password",passController,TextInputType.visiblePassword,true),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: LoginBtn('SIGN UP', (){signup();}, CustomAppTheme.btnWhiteText),
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

  loginPress(){
    print('login');
    Navigator.of(context).pop();
  }

  signup(){
    String firstName=firstNameController.text.trim();
    String lastName=lastNameController.text.trim();
    String email=emailController.text.trim();
    String mobile=mobileController.text.trim();
    String pass=passController.text.trim();

    if(firstName.isEmpty){
      showSnackBar(context,"Enter firstname");
      return;
    }

    if(lastName.isEmpty){
      showSnackBar(context,"Enter lastname");
      return;
    }

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
    ApiService.instance.signup(firstName,lastName,email,mobile,pass).then((value) {

      var extractData = json.decode(value.body);
      if(value.statusCode==200){
        showSnackBar(context,extractData['message']);
        loginPress();
      }else{
        showSnackBar(context,extractData['message']);
      }

      setState(() {
        _isInAsyncCall=false;
      });


    });
  }

}
