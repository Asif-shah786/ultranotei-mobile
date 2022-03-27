import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class DialogTextField extends StatefulWidget {
  String hint;

  TextEditingController controlller;

  var inputType;

  bool isPass;

  DialogTextField(this.hint,this.controlller,inputType,this.isPass);

  @override
  State<DialogTextField> createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<DialogTextField> {

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
        contentPadding: EdgeInsets.all(10),
        isDense: true,
        fillColor: Colors.white,
        filled:true,
        hintText: widget.hint,
        hintStyle: CustomAppTheme.inputHint2Text,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        //labelText: 'User Name',
      ),
    );
  }
}
