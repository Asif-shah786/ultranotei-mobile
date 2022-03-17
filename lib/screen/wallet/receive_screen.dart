import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/widget/my_wallet_card.dart';

import '../../app_theme.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> with AutomaticKeepAliveClientMixin<ReceiveScreen> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 35,),
              Text('Receiving Bitcoin Address:',style: CustomAppTheme.btnWhiteText,),
              SizedBox(height: 35,),
              Text('0xA29882393E7caBf87E970C42567d180d198EF5D9',style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              InkWell(
                  onTap: (){
                    copy();
                  },
                  child: Text("Copy Address",style: CustomAppTheme.smallBlueText,textAlign: TextAlign.center,)),
              SizedBox(height: 30,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Transaction fee: ",style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                  Text("0.00009BTC",style: CustomAppTheme.smallBlueBoldText,textAlign: TextAlign.center,),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        //MyWalletCard('0.00000937BTC','0.0BTC'),
        MyWalletCard('0.0','0.0'),
      ],
    );
  }

  copy(){
    print('copy');
  }
}
