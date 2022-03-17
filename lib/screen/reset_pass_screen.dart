import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/input_auth_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import '../app_theme.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({Key? key}) : super(key: key);

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {

  TextEditingController oldPassController=TextEditingController();
  TextEditingController newPassController=TextEditingController();
  TextEditingController confirmNewPassController=TextEditingController();
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
            backgroundColor: CustomAppTheme.black_bar,
            elevation: 0,
            centerTitle: true,
            title: Text('Reset Password', style: CustomAppTheme.actionBarText),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: InputAuthField("Old Password",oldPassController,TextInputType.visiblePassword,true),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: InputAuthField("New Password",newPassController,TextInputType.visiblePassword,true),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: InputAuthField("Confirm New Password",confirmNewPassController,TextInputType.visiblePassword,true),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: LoginBtn('RESET', (){resetPass();}, CustomAppTheme.btnWhiteText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  resetPass(){

    String oldPass=oldPassController.text.trim();
    String newPass=newPassController.text.trim();
    String confirmNewPass=confirmNewPassController.text.trim();

    if(oldPass.isEmpty){
      showSnackBar(context,"Enter old password");
      return;
    }

    if(newPass.isEmpty){
      showSnackBar(context,"Enter new password");
      return;
    }

    if(confirmNewPass.isEmpty){
      showSnackBar(context,"Retype new password");
      return;
    }

    if(newPass!=confirmNewPass){
      showSnackBar(context,"Password doesn't match");
      return;
    }

    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      if(oldPass!=cvalue.pass){
        showSnackBar(context,"Wrong old password");
        return;
      }

      setState(() {
        _isInAsyncCall=true;
      });
      ApiService.instance.resetpass(newPass, cvalue.token).then((value) {

        var extractData = json.decode(value.body);
        if(value.statusCode==200){
          CurrentUser currentUser =cvalue;
          currentUser.pass=newPass;
          UserLocalStore userLocalStore = new UserLocalStore();
          userLocalStore.storeUserData(currentUser);
          showSnackBar(context,extractData['message']);

        }else{
          showSnackBar(context,extractData['message']);
        }

        setState(() {
          _isInAsyncCall=false;
        });


      });
    });

  }
}
