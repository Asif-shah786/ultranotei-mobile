import 'package:flutter/material.dart';
import 'package:ultranote_infinity/screen/activity_log_screen.dart';
import 'package:ultranote_infinity/screen/edit_profile_screen.dart';
import 'package:ultranote_infinity/screen/forgotpassscreen.dart';
import 'package:ultranote_infinity/screen/home_screen.dart';
import 'package:ultranote_infinity/screen/login_screen.dart';
import 'package:ultranote_infinity/screen/login_signup_screen.dart';
import 'package:ultranote_infinity/screen/otp_screen.dart';
import 'package:ultranote_infinity/screen/reset_pass_screen.dart';
import 'package:ultranote_infinity/screen/setting_screen.dart';
import 'package:ultranote_infinity/screen/splash_screen.dart';
import 'package:ultranote_infinity/screen/wallet_screen.dart';

import 'screen/signup_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    title: "",
    initialRoute: '/',
    routes: {
      '/':(context) =>SplashScreen(),
      '/loginsignupscreen':(context) =>LoginSignupScreen(),
      '/loginscreen':(context) =>LoginScreen(),
      '/signupscreen':(context) =>SignupScreen(),
      '/forgotpassscreen':(context) =>ForgotPassScreen(),
      '/homescreen':(context) =>HomeScreen(),
      '/editprofilescreen':(context) =>EditProfileScreen(),
      '/resetpassscreen':(context) =>ResetPassScreen(),
      '/activitylogscreen':(context) =>ActivityLogScreen(),
      '/setingscreen':(context) =>SettingScreen(),
    },
    theme: ThemeData(fontFamily: 'Metropolis'),
  ));
}

