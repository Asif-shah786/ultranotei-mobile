import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class BuyCard extends StatefulWidget {
  const BuyCard({Key? key}) : super(key: key);

  @override
  State<BuyCard> createState() => _BuyCardState();
}

class _BuyCardState extends State<BuyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: CustomAppTheme.transparentpurple,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Danger156',style: CustomAppTheme.smallBlueText,),
                Spacer(),
                Text('> 30min',style: CustomAppTheme.smallWhiteText,)
              ],
            ),
            SizedBox(height: 5,),
            Container(height: 1,color: Colors.white,width: double.infinity,),
            SizedBox(height: 8,),
            Text('404872.79 SEK/BTC',style: CustomAppTheme.largePinkBoldText,),
            SizedBox(height: 10,),
            Text('Swish',style: CustomAppTheme.smallGreyText,),
            SizedBox(height: 10,),
            Container(height: 1,color: Colors.white,width: double.infinity,),

            SizedBox(height: 5,),

            Row(
              children: [
                Text('500.00-5000.00 SEK',style: CustomAppTheme.smallWhiteText,),
                Spacer(),
                Text('34',style: CustomAppTheme.smallWhiteText,),
                SizedBox(width: 30,),
                Text('100%',style: CustomAppTheme.smallWhiteText,)
              ],
            ),

          ],
        ),
      ),
    );
  }
}
