import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/app_theme.dart';

class LoginBtn extends StatefulWidget {
  String text;
  var onPressed;
  var textStyle;

  LoginBtn(this.text, this.onPressed, this.textStyle);

  @override
  State<LoginBtn> createState() => _LoginBtnState();
}

class _LoginBtnState extends State<LoginBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        primary: CustomAppTheme.black_login,
        // fromHeight use double.infinity as width and 40 is the height
      ),
      /*  ButtonStyle(
        backgroundColor:MaterialStateProperty.all<Color>(CustomAppTheme.black_login),
      ),*/
        onPressed: widget.onPressed,
        child: Text(widget.text, style: widget.textStyle));
  }
}
