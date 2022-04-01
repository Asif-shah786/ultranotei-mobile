import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';
import 'package:ultranote_infinity/widget/signup_btn.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {

  @override
  Widget build(BuildContext context) {


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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
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
            SizedBox(height: 45,),
            Text("Ultranote Infinity",
            style: CustomAppTheme.startText,),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Text("UltraNote Infinity encrypted wallet and messaging system with up to 100MB file transfers.",
                style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
            ),
            SizedBox(height: 35,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: LoginBtn('LOGIN', (){loginPress();}, CustomAppTheme.btnWhiteText),
            ),
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: SignupBtn('SIGNUP', (){signupPress();}, CustomAppTheme.btnBlackText),
            ),
          ],
        ),
      ),
    );
  }

  loginPress(){
    print('login press');
    Navigator.pushNamed(context, '/loginscreen');
  }

  signupPress(){
    print('signup press');
    Navigator.pushNamed(context, '/signupscreen');
  }
}
