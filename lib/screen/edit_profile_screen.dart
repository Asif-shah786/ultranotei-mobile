import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/input_auth_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';

import '../app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController mobileController=TextEditingController();
  bool _isInAsyncCall = false;

  String id='';
  String firstName='';
  String lastName='';
  String mail='';
  String phone='';
  String token='';
  late CurrentUser cvalue ;

  getUser(){
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((value) {
      setState(() {
        cvalue=value;

        id=value.id;
        firstName=value.firstName;
        lastName=value.lastName;
        mail=value.email;
        phone=value.mobile;
        token=value.token;

        firstNameController.text=firstName;
        lastNameController.text=lastName;
        emailController.text=mail;
        mobileController.text=phone;

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
            title: Text('Edit Profile', style: CustomAppTheme.actionBarText),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [

              SizedBox(height: 50,),
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
              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: InputAuthField("Mobile",mobileController,TextInputType.number,false),
                ),
              ),
              SizedBox(height: 0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: LoginBtn('UPDATE', (){submit();}, CustomAppTheme.btnWhiteText),
              ),
              SizedBox(height: 15,),
            ],
          )),
        ),
      ),
    );
  }
  submit(){

    firstName=firstNameController.text.trim();
    lastName=lastNameController.text.trim();
    mail=emailController.text.trim();
    phone=mobileController.text.trim();

    if(firstName.isEmpty){
      showSnackBar(context,"Enter Firstname");
      return;
    }
    if(lastName.isEmpty){
      showSnackBar(context,"Enter lastname");
      return;
    }
    if(mail.isEmpty){
      showSnackBar(context,"Enter email");
      return;
    }
   /* if(phone.isEmpty){
      showSnackBar(context,"Enter mobile number");
      return;
    }*/


    setState(() {
      _isInAsyncCall=true;
    });
    ApiService.instance.editprofile(id,firstName,lastName,mail,phone,token).then((value) {

      print(value.body.toString());
      var extractData = json.decode(value.body);
      if(value.statusCode==200){
        CurrentUser currentUser =cvalue;
        currentUser.firstName=firstName;
        currentUser.lastName=lastName;
        currentUser.email=mail;
        currentUser.mobile=phone;
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

  }
}
