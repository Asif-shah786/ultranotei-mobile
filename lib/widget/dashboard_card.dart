import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/utils/utils.dart';

import '../app_theme.dart';

class DashboardCard extends StatefulWidget {

  String AXUNI;
  String AUSD;
  String UXUNI;
  String UUSD;


  DashboardCard(this.AXUNI, this.AUSD, this.UXUNI, this.UUSD);

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: CustomAppTheme.transparentpurple,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text('Available Balance',style: CustomAppTheme.largePinkBoldText,),
            SizedBox(height: 10,),
            Container(height: 1,color: Colors.white,width: double.infinity,),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Row(
                  children: [
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
                    SizedBox(width: 7,),
                    Text('${widget.AXUNI} XUNI',style: CustomAppTheme.smallBlueText,),
                  ],
                ),

                SizedBox(height: 5,),
                Text('${widget.AUSD} USD',style: CustomAppTheme.smallBlueText,),

              ],
            ),

            SizedBox(height: 20,),
            Container(height: 2,color: Colors.white,width: double.infinity,),
            SizedBox(height: 20,),
            Text('Unconfirmed Balance',style: CustomAppTheme.largePinkBoldText,),
            SizedBox(height: 10,),
            Container(height: 1,color: Colors.white,width: double.infinity,),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
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
                    SizedBox(width: 7,),
                    Text('${widget.UXUNI} XUNI',style: CustomAppTheme.smallBlueText,),
                  ],
                ),

                SizedBox(height: 5,),
                Text('${widget.UUSD} USD',style: CustomAppTheme.smallBlueText,),

              ],
            ),



          ],
        ),
      ),
    );
  }
}
