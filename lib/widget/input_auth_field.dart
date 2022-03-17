import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/app_theme.dart';

class InputAuthField extends StatefulWidget {
  String hint;

  TextEditingController controlller;

  var inputType;

  bool isPass;

  InputAuthField(this.hint,this.controlller,inputType,this.isPass);

  @override
  State<InputAuthField> createState() => _InputAuthFieldState();
}

class _InputAuthFieldState extends State<InputAuthField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controlller,
      keyboardType: widget.inputType,
      style: CustomAppTheme.inputText,
      obscureText: widget.isPass,
      enableSuggestions: !widget.isPass,
      autocorrect: !widget.isPass,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        isDense: true,
        fillColor: Colors.white,
        filled:true,
        hintText: widget.hint,
        hintStyle: CustomAppTheme.inputHintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        //labelText: 'User Name',
      ),
    );
  }
}
