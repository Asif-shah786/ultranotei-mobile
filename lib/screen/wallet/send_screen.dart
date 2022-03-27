import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/input_address_field.dart';
import 'package:ultranote_infinity/widget/input_amount_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';
import 'package:ultranote_infinity/widget/my_wallet_card.dart';

import '../scan_qr_code_screen.dart';

class SendScreen extends StatefulWidget {

  String ADDRESS;
  String BALANCE;


  SendScreen(this.ADDRESS,this.BALANCE);

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> with AutomaticKeepAliveClientMixin<SendScreen>  {

  @override
  bool get wantKeepAlive => true;

  TextEditingController addressController=TextEditingController();
  TextEditingController paymentIdController=TextEditingController();
  TextEditingController amountController=TextEditingController();
  TextEditingController noteController=TextEditingController();

  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isInAsyncCall,
      child: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text('Address',style: CustomAppTheme.smallWhiteText,),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(child: InputAddressField("Enter XUIN address",addressController,TextInputType.name,false)),
                      IconButton(
                        padding: EdgeInsets.all(4),
                        onPressed:()  {
                        FlutterClipboard.paste().then((value) {
                          // Do what ever you want with the value.
                          setState(() {
                            addressController.text = value;
                          });
                        });
                      }, icon: Icon(Icons.paste),color: Colors.white,),
                      IconButton(
                        padding: EdgeInsets.all(4),
                        onPressed:(){

                          FocusScope.of(context).requestFocus(FocusNode());
                          Future.delayed(const Duration(milliseconds: 200), () {

                            Navigator.of(context)
                                .push(
                              new MaterialPageRoute(
                                  builder: (_) => new ScanQRCodeScreen()),
                            )
                                .then((val) => val ? setAddress() : null);

                          });

                        }, icon: Icon(Icons.qr_code),color: Colors.white,),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('Payment ID',style: CustomAppTheme.smallWhiteText,),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(child: InputAddressField("Enter payment id",paymentIdController,TextInputType.name,false)),
                      IconButton(
                        padding: EdgeInsets.all(4),
                        onPressed:()  {
                        FlutterClipboard.paste().then((value) {
                          // Do what ever you want with the value.
                          setState(() {
                            paymentIdController.text = value;
                          });
                        });
                      }, icon: Icon(Icons.paste),color: Colors.white,),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('Amount',style: CustomAppTheme.smallWhiteText,),
                  SizedBox(height: 5,),
                  InputAmountField("Enter amount",amountController,TextInputType.numberWithOptions(decimal: true),false),
                  SizedBox(height: 5,),
                  Text("Amount in bits, Ex: 1000000 = 1 XUNI coin",style: CustomAppTheme.smallWhiteText,),
                  SizedBox(height: 20,),
                  Text('Note',style: CustomAppTheme.smallWhiteText,),
                  SizedBox(height: 5,),
                  InputAddressField("Enter note",noteController,TextInputType.name,false),
                  SizedBox(height: 20,),
             /*     Row(
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
                  ),*/
                  //SizedBox(height: 10,),
                  LoginBtn("Send", (){onSend();}, CustomAppTheme.btnWhiteText),
                  SizedBox(height: 20,),


                ],
              ),
            ),
          ),),

          //MyWalletCard('0.00000937BTC','0.0BTC'),
          MyWalletCard('${(double.parse(widget.BALANCE)).toStringAsFixed(6)} XUNI','0.0'),
        ],
      ),
    );
  }

  setAddress() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String address = sp.getString('address')!;

    setState(() {
      addressController.text=address;

    });
  }
  onSend(){
    String recepientAddress=addressController.text.toString().trim();
    String paymentId=paymentIdController.text.toString().trim();
    String amount=amountController.text.toString().trim();
    String note=noteController.text.toString().trim();

    if(recepientAddress.isEmpty){
      showSnackBar(context,"Enter XUIN address");
      return;
    }

    if(amount.isEmpty){
      showSnackBar(context,"Enter amount");
      return;
    }

    if(note.isEmpty){
      showSnackBar(context,"Enter note");
      return;
    }

    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {

      setState(() {
        _isInAsyncCall=true;
      });
      ApiService.instance.withdraw(cvalue.id,widget.ADDRESS,recepientAddress,amount,note,paymentId).then((value) {

        setState(() {
          _isInAsyncCall=false;
        });
        var extractData = json.decode(value.body);
        if(value.statusCode==200){
          showSnackBar(context,extractData['message'].toString());
          Navigator.of(context).pushNamedAndRemoveUntil('/homescreen', (Route<dynamic> route) => false);
        }else{
          showSnackBar(context,extractData['message'].toString());
        }

      });
    });
  }

}
