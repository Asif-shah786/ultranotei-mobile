import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class MyWalletCard extends StatefulWidget {

  String inWallet;
  String upTo;

  MyWalletCard(this.inWallet, this.upTo);

  @override
  State<MyWalletCard> createState() => _MyWalletCardState();
}

class _MyWalletCardState extends State<MyWalletCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            color: CustomAppTheme.cardpurple,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Wallet",style: CustomAppTheme.btnWhiteText,),
            SizedBox(height: 15,),
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("In your wallet: ",style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                SizedBox(width: 5,),
                Container(
                  width: 21,
                  height: 20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icon/grey.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Text(widget.inWallet,style: CustomAppTheme.smallBlueBoldText,textAlign: TextAlign.center,),
              ],
            ),
            SizedBox(height: 5,),
           /* Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("You can send up to: ",style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                Text(widget.upTo,style: CustomAppTheme.smallBlueBoldText,textAlign: TextAlign.center,),
              ],
            ),*/
            SizedBox(height: 45,)
          ],
        )
    );
  }
}
