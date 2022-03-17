import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class SignupBtn extends StatefulWidget {

  String text;
  var onPressed;
  var textStyle;

  SignupBtn(this.text, this.onPressed, this.textStyle);


  @override
  State<SignupBtn> createState() => _SignupBtnState();
}

class _SignupBtnState extends State<SignupBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
          primary: Colors.white,
          // fromHeight use double.infinity as width and 40 is the height
        ),
        /*  ButtonStyle(
        backgroundColor:MaterialStateProperty.all<Color>(CustomAppTheme.black_login),
      ),*/
        onPressed: widget.onPressed,
        child: Text(widget.text, style: widget.textStyle));
  }
}
