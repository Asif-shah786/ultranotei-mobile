import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/widget/dropdowncustom.dart';
import 'package:ultranote_infinity/widget/history_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin<HistoryScreen> {
  @override
  bool get wantKeepAlive => true;

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
              child: HistoryCard(i%2==0?true:false,"0.00115482BTC","Bitcoin sell #77244862 Tedson(500+; 100%)","02/09/2022 | 9:41PM"),
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
