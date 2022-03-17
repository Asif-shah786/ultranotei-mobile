import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/widget/buy_card.dart';
import 'package:ultranote_infinity/widget/dropdowncustom.dart';

import '../../app_theme.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({Key? key}) : super(key: key);

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {

  String selectedValue = 'Item 1';

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomAppTheme.purple_tab,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 5.0,
                offset: Offset(0.0, 1.75))
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: DropDownCustom(selectedValue, items, (_) {
          onChange(_);
        }),
      ),
      Container(
        child: Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: BuyCard(),
            ),
          ),
        ),
      )
    ]);
  }

  onChange(String value) {
    print(value);
    setState(() {
      selectedValue = value;
    });
  }
}
