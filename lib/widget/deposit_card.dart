import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class DepositCard extends StatefulWidget {
  String id;
  String status;
  String amount;
  String interest;
  String sum;
  String rate;
  String unlockHeight;
  String unlockTime;
  DepositCard(this.id, this.status, this.amount, this.interest, this.sum,
      this.rate, this.unlockHeight, this.unlockTime);
  @override
  State<DepositCard> createState() => _DepositCardState();
}

class _DepositCardState extends State<DepositCard> {
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
                widget.status,
                style: CustomAppTheme.smallWhiteBoldText,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    'Amount : ${widget.amount} XUNI',
                    style: CustomAppTheme.smallWhiteText,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Sum : ${widget.sum} XUNI',
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
                    widget.unlockTime,
                    style: CustomAppTheme.smallGreyText,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
