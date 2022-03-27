import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/my_wallet_card.dart';

import '../../app_theme.dart';

class ReceiveScreen extends StatefulWidget {

  String WALLETADDRESS;
  String SPENDKEY;
  String VIEWKEY;
  String BALANCE;


  ReceiveScreen(this.WALLETADDRESS, this.SPENDKEY, this.VIEWKEY,this.BALANCE);

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> with AutomaticKeepAliveClientMixin<ReceiveScreen> {

  @override
  bool get wantKeepAlive => true;

  String walletAddress='';
  String spendKey='';
  String viewKey='';

  bool isKeyShow=false;

  @override
  void initState() {
    // TODO: implement initState
    walletAddress=widget.WALLETADDRESS;
    spendKey=widget.SPENDKEY;
    viewKey=widget.VIEWKEY;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 35,),
                  Text('Receiving Address:',style: CustomAppTheme.btnWhiteText,),
                  SizedBox(height: 20,),
                  Container(
                    width:200,
                    height:200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=${walletAddress}"
                        ),
                        fit: BoxFit.fill,
                      ),),
                  ),
                  SizedBox(height: 20,),
                  Text('${walletAddress}',style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                  SizedBox(height: 10,),
                  InkWell(
                      onTap: (){
                        copyAddress();
                      },
                      child: Text("Copy Address",style: CustomAppTheme.smallBlueText,textAlign: TextAlign.center,)),
                  SizedBox(height: 30,),
                  Visibility(
                    visible: !isKeyShow,
                      child: InkWell(
                        onTap: (){
                          showKey();
                        },
                          child: Text('Show Key',style: CustomAppTheme.largePinkBoldText,))),
                  Visibility(
                    visible: isKeyShow,
                    child: Column(
                      children: [
                        Text('Spend Key:',style: CustomAppTheme.btnWhiteText,),
                        SizedBox(height: 15,),
                        Text('${spendKey}',style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                        SizedBox(height: 10,),
                        InkWell(
                            onTap: (){
                              copySpendKey();
                            },
                            child: Text("Copy Spend Key",style: CustomAppTheme.smallBlueText,textAlign: TextAlign.center,)),
                        SizedBox(height: 30,),
                        Text('View Key:',style: CustomAppTheme.btnWhiteText,),
                        SizedBox(height: 15,),
                        Text('${viewKey}',style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                        SizedBox(height: 10,),
                        InkWell(
                            onTap: (){
                              copyViewKey();
                            },
                            child: Text("Copy View Key",style: CustomAppTheme.smallBlueText,textAlign: TextAlign.center,)),
                      ],
                    ),
                  ),

                  SizedBox(height: 30,),
                 /* Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Transaction fee: ",style: CustomAppTheme.smallWhiteText,textAlign: TextAlign.center,),
                      Text("0.00009BTC",style: CustomAppTheme.smallBlueBoldText,textAlign: TextAlign.center,),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ),
        //MyWalletCard('0.00000937BTC','0.0BTC'),
        MyWalletCard('${(double.parse(widget.BALANCE)).toStringAsFixed(6)} XUNI','0.0'),
      ],
    );
  }

  showKey(){
    setState(() {
      isKeyShow=true;
    });
  }

  copyAddress(){
    Clipboard.setData(ClipboardData(text: "${walletAddress}"));
    showSnackBar(context,'Wallet address copied successfully');
  }

  copySpendKey(){
    Clipboard.setData(ClipboardData(text: "${spendKey}"));
    showSnackBar(context,'Spend key copied successfully');
  }

  copyViewKey(){
    Clipboard.setData(ClipboardData(text: "${viewKey}"));
    showSnackBar(context,'View key copied successfully');
  }
}
