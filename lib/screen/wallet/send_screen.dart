import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/widget/input_address_field.dart';
import 'package:ultranote_infinity/widget/input_amount_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';
import 'package:ultranote_infinity/widget/my_wallet_card.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({Key? key}) : super(key: key);

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> with AutomaticKeepAliveClientMixin<SendScreen>  {

  @override
  bool get wantKeepAlive => true;

  TextEditingController addressController=TextEditingController();
  TextEditingController amountController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text('Address',style: CustomAppTheme.smallWhiteText,),
              SizedBox(height: 5,),
              InputAddressField("Enter the receiving address:",addressController,TextInputType.name,false),
              SizedBox(height: 20,),
              Text('Amount',style: CustomAppTheme.smallWhiteText,),
              SizedBox(height: 5,),
              InputAmountField("0.00",amountController,TextInputType.numberWithOptions(decimal: true),false),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Set max amount for sending",style: CustomAppTheme.smallBlueText,textAlign: TextAlign.center,),
                ],
              ),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Transaction fee: ",style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                  Text("0.00009BTC",style: CustomAppTheme.smallBlueBoldText,textAlign: TextAlign.center,),
                ],
              ),
              SizedBox(height: 20,),
              LoginBtn("Preview", (){onPreview();}, CustomAppTheme.btnWhiteText)


            ],
          ),
        ),
        Spacer(),
        //MyWalletCard('0.00000937BTC','0.0BTC'),
        MyWalletCard('0.0','0.0'),
      ],
    );
  }

  onPreview(){
    print('preview');
  }
}
