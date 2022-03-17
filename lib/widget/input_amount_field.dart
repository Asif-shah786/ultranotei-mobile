import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';

class InputAmountField extends StatefulWidget {

  String hint;

  TextEditingController controlller;

  var inputType;

  bool isPass;

  InputAmountField(this.hint,this.controlller,inputType,this.isPass);

  @override
  State<InputAmountField> createState() => _InputAmountFieldState();
}

class _InputAmountFieldState extends State<InputAmountField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controlller,
      keyboardType: widget.inputType,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
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
