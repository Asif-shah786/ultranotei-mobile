import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:slider_captcha/presentation/screens/slider_captcha.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/contacts/contact_controller.dart';
import 'package:ultranote_infinity/screen/contacts/contact_list_model.dart';
import 'package:ultranote_infinity/screen/otp_screen.dart';
import 'package:ultranote_infinity/screen/twoFAScreen.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _isInAsyncCall = false;
  bool? iscaptcha = false;

  @override
  void initState() {
    super.initState();
  }

  void addPostFrameCallback(FrameCallback callback) {
    var _postFrameCallbacks;
    _postFrameCallbacks.add(callback);
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
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "LOGIN",
                    style: CustomAppTheme.startText,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Email", emailController,
                        TextInputType.emailAddress, false),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: InputAuthField("Password", passController,
                        TextInputType.visiblePassword, true),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        forgotPass();
                      },
                      child: Text(
                        "Forgot your password?",
                        style: CustomAppTheme.smallBlueText,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: CustomAppTheme.black_login,
                            side: BorderSide(color: Colors.white),
                            value: iscaptcha,
                            onChanged: (v) {
                              setState(() {
                                iscaptcha = v;
                              });
                              print(v);
                            }),
                        Text(
                          "Verify Captcha!",
                          style: CustomAppTheme.smallWhiteText,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: LoginBtn('LOGIN', () {
                      loginPress();
                    }, CustomAppTheme.btnWhiteText),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have account? ",
                        style: CustomAppTheme.smallWhiteText,
                        textAlign: TextAlign.center,
                      ),
                      InkWell(
                          onTap: () {
                            signup();
                          },
                          child: Text(
                            "Sign up",
                            style: CustomAppTheme.smallBlueBoldText,
                            textAlign: TextAlign.center,
                          )),
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

  loginPress() {
    if (iscaptcha == true) {
      print('login');

      String email = emailController.text.trim();
      String pass = passController.text.trim();

      if (email.isEmpty) {
        showSnackBar(context, "Enter email");
        return;
      }

      if (pass.isEmpty) {
        showSnackBar(context, "Enter pass");
        return;
      }

      setState(() {
        _isInAsyncCall = true;
      });
      ApiService.instance.login(email, pass).then((value) {
        var extractData = json.decode(value.body);
        if (value.statusCode == 200) {
          log(extractData.toString());
          print('name  ${extractData.toString()}');
          print('IMAGEss ${extractData['user']['image']}');
          List demoList = extractData['user']['contacts'];
          ContactController.to.clearList();
          for (int i = 0; i < demoList.length; i++) {
            var label = demoList[i][0];
            var addresee = demoList[i][1];
            ContactListMOdel model =
                ContactListMOdel(address: addresee, label: label);
            ContactListMOdel.contactList.add(model);
          }
          print('check List${ContactListMOdel.contactList.length}');

          ContactController.to.getContactList(ContactListMOdel.contactList);

          print(
              'login Detail for the user${ContactListMOdel.contactList.length}');

          if (extractData['message'] == "OTP steps") {
            showSnackBar(context, extractData['message']);

            showDialog(
                context: context,
                builder: (BuildContext c) {
                  return Dialog(
                    child: Container(
                      height: 280,
                      width: 280,
                      padding: const EdgeInsets.all(8.0),
                      child: SliderCaptcha(
                          image: Image.asset(
                            'assets/puzzle.jpeg',
                            fit: BoxFit.fitWidth,
                          ),
                          onSuccess: () {
                            Navigator.pop(c);
                            showSnackBar(context, "Verify captcha");
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OTPScreen(
                                        pass, extractData['token'].toString()),
                                  ));
                            });
                          }),
                    ),
                  );
                });
          } else if (extractData['message'] == "2FA steps") {
            showSnackBar(context, extractData['message']);
            showDialog(
                context: context,
                builder: (BuildContext c) {
                  return Dialog(
                    child: Container(
                      height: 280,
                      width: 280,
                      padding: const EdgeInsets.all(8.0),
                      child: SliderCaptcha(
                          image: Image.asset(
                            'assets/puzzle.jpeg',
                            fit: BoxFit.fitWidth,
                          ),
                          onSuccess: () {
                            Navigator.pop(c);
                            showSnackBar(context, "Verify captcha");
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TwoFAScreen(
                                        pass, extractData['token'].toString()),
                                  ));
                            });
                          }),
                    ),
                  );
                });
          } else {
            CurrentUser currentUser = new CurrentUser(
                extractData['user']['firstName'].toString(),
                extractData['user']['lastName'].toString(),
                extractData['user']['mail'].toString(),
                extractData['user']['phone'].toString(),
                extractData['user']['otp_auth'].toString(),
                extractData['user']['two_fact_auth'].toString(),
                extractData['user']['isActive'].toString(),
                extractData['user']['isWalletCreated'].toString(),
                extractData['user']['currency'].toString(),
                extractData['user']['id'].toString(),
                extractData['user']['image'].toString(),
                extractData['token'].toString(),
                pass);
            UserLocalStore userLocalStore = new UserLocalStore();
            userLocalStore.storeUserData(currentUser);
            showSnackBar(context, extractData['message']);

            showDialog(
                context: context,
                builder: (BuildContext c) {
                  return Dialog(
                    child: Container(
                      height: 280,
                      width: 280,
                      padding: const EdgeInsets.all(8.0),
                      child: SliderCaptcha(
                          image: Image.asset(
                            'assets/puzzle.jpeg',
                            fit: BoxFit.fitWidth,
                          ),
                          onSuccess: () {
                            Navigator.pop(c);
                            showSnackBar(context, "Verify captcha");
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/homescreen',
                                  (Route<dynamic> route) => false);
                            });
                          }),
                    ),
                  );
                });
          }
        } else {
          showSnackBar(context, extractData['message']);
        }

        setState(() {
          _isInAsyncCall = false;
        });
      });
    } else {
      showSnackBar(context, "Verify captcha First");
    }
  }
  // loginPress() {
  //   if (iscaptcha == true) {
  //     print('login');

  //     String email = emailController.text.trim();
  //     String pass = passController.text.trim();

  //     if (email.isEmpty) {
  //       showSnackBar(context, "Enter email");
  //       return;
  //     }

  //     if (pass.isEmpty) {
  //       showSnackBar(context, "Enter pass");
  //       return;
  //     }

  //     setState(() {
  //       _isInAsyncCall = true;
  //     });
  //     ApiService.instance.login(email, pass).then((value) {
  //       var extractData = json.decode(value.body);
  //       if (value.statusCode == 200) {
  //         print('name  ${extractData.toString()}');
  //         print(' ${extractData['user']['contacts']}');
  //         List demoList = extractData['user']['contacts'];
  //         ContactController.to.clearList();
  //         for (int i = 0; i < demoList.length; i++) {
  //           var label = demoList[i][0];
  //           var addresee = demoList[i][1];
  //           ContactListMOdel model =
  //               ContactListMOdel(address: addresee, label: label);
  //           ContactListMOdel.contactList.add(model);
  //         }
  //         print('check List${ContactListMOdel.contactList.length}');

  //         ContactController.to.getContactList(ContactListMOdel.contactList);

  //         print(
  //             'login Detail for the user${ContactListMOdel.contactList.length}');

  //         if (extractData['user']['two_fact_auth'] == true) {
  //           showSnackBar(context, extractData['message']);

  //           showDialog(
  //               context: context,
  //               builder: (BuildContext c) {
  //                 return Dialog(
  //                   child: Container(
  //                     height: 280,
  //                     width: 280,
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: SliderCaptcha(
  //                         image: Image.asset(
  //                           'assets/puzzle.jpeg',
  //                           fit: BoxFit.fitWidth,
  //                         ),
  //                         onSuccess: () {
  //                           Navigator.pop(c);
  //                           showSnackBar(context, "Verify captcha");
  //                           Future.delayed(Duration(seconds: 2), () {
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) => OTPScreen(
  //                                       pass, extractData['token'].toString()),
  //                                 ));
  //                           });
  //                         }),
  //                   ),
  //                 );
  //               });
  //         } else {
  //           CurrentUser currentUser = new CurrentUser(
  //               extractData['user']['firstName'].toString(),
  //               extractData['user']['lastName'].toString(),
  //               extractData['user']['mail'].toString(),
  //               extractData['user']['phone'].toString(),
  //               extractData['user']['two_fact_auth'].toString(),
  //               extractData['user']['isActive'].toString(),
  //               extractData['user']['isWalletCreated'].toString(),
  //               extractData['user']['currency'].toString(),
  //               extractData['user']['id'].toString(),
  //               extractData['token'].toString(),
  //               pass);
  //           UserLocalStore userLocalStore = new UserLocalStore();
  //           userLocalStore.storeUserData(currentUser);
  //           showSnackBar(context, extractData['message']);

  //           showDialog(
  //               context: context,
  //               builder: (BuildContext c) {
  //                 return Dialog(
  //                   child: Container(
  //                     height: 280,
  //                     width: 280,
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: SliderCaptcha(
  //                         image: Image.asset(
  //                           'assets/puzzle.jpeg',
  //                           fit: BoxFit.fitWidth,
  //                         ),
  //                         onSuccess: () {
  //                           Navigator.pop(c);
  //                           showSnackBar(context, "Verify captcha");
  //                           Future.delayed(Duration(seconds: 2), () {
  //                             Navigator.of(context).pushNamedAndRemoveUntil(
  //                                 '/homescreen',
  //                                 (Route<dynamic> route) => false);
  //                           });
  //                         }),
  //                   ),
  //                 );
  //               });
  //         }
  //       } else {
  //         showSnackBar(context, extractData['message']);
  //       }

  //       setState(() {
  //         _isInAsyncCall = false;
  //       });
  //     });
  //   } else {
  //     showSnackBar(context, "Verify captcha First");
  //   }
  // }

  signup() {
    print('signup');
    Navigator.pushNamed(context, '/signupscreen');
  }

  forgotPass() {
    print('forgotPass');
    Navigator.pushNamed(context, '/forgotpassscreen');
  }
}
