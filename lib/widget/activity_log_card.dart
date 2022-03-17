import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class ActivityLog extends StatefulWidget {

  String note;
  String ip;
  String time;


  ActivityLog(this.note, this.ip, this.time);

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
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
            Text(
              'IP : ${widget.ip}',
              style: CustomAppTheme.smallWhiteText,
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
