import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/app_theme.dart';

class HistoryCard extends StatefulWidget {
  bool isSent;
  String price;
  String note;
  String time;

  HistoryCard(this.isSent, this.price, this.note, this.time);

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
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
            Row(
              children: [
                Text(
                  widget.isSent ? '-Sent' : '+Received',
                  style: widget.isSent
                      ? CustomAppTheme.smallPinkBoldText
                      : CustomAppTheme.smallBlueBoldText,
                ),
                Spacer(),
                Text(
                  widget.price,
                  style: CustomAppTheme.smallWhiteBoldText,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.note,
              style: CustomAppTheme.smallWhiteText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.time,
              style: CustomAppTheme.smallGreyText,
            ),
          ],
        ),
      ),
    );
  }
}
