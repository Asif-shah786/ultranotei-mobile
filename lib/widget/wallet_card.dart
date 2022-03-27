import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class WalletCard extends StatefulWidget {

  String note;
  String ip;
  String time;


  WalletCard(this.note, this.ip, this.time);

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: CustomAppTheme.transparentpurple,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              widget.note,
              style: CustomAppTheme.smallWhiteBoldText,
            ),
            SizedBox(
              height: 8,
            ),

            Row(
              children: [
                Container(
                  width: 19,
                  height: 18,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icon/grey.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Balance : ${widget.ip}',
                  style: CustomAppTheme.smallWhiteText,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.time,
                  style: CustomAppTheme.smallGreyText,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
