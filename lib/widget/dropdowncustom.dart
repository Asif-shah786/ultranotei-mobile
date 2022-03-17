import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownCustom extends StatefulWidget {

  String selected;
  List list;
  var onChange;


  DropDownCustom(this.selected, this.list, this.onChange);

  @override
  State<DropDownCustom> createState() => _DropDownCustomState();
}

class _DropDownCustomState extends State<DropDownCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(

          // Initial Value
          value: widget.selected,

          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: widget.list.map((items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
