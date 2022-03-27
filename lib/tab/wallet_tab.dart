import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/wallet/history_screen.dart';
import 'package:ultranote_infinity/screen/wallet/receive_screen.dart';
import 'package:ultranote_infinity/screen/wallet/send_screen.dart';
import 'package:ultranote_infinity/screen/wallet_screen.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/activity_log_card.dart';
import 'package:ultranote_infinity/widget/dialog_text_field.dart';
import 'package:ultranote_infinity/widget/input_address_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';
import 'package:ultranote_infinity/widget/wallet_card.dart';

import '../../app_theme.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _WalletTabState createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  final ScrollController scrollController = ScrollController();

  double topBarOpacity = 0.0;

  bool _isInAsyncCall = false;
  List list = [];

  bool isWalletCreated=true;

  getWallets() {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      setState(() {
        isWalletCreated=cvalue.isWalletCreated=="true"?true:false;
        _isInAsyncCall = true;
      });
      ApiService.instance.mywallet(cvalue.id).then((value) {
        setState(() {
          list = value[0];
          print(list.length);
          _isInAsyncCall = false;
        });
      });
    });
  }

  @override
  void initState() {
    getWallets();

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 62),
      child: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: CustomAppTheme.black_bar,
            elevation: 0,
            centerTitle: true,
            title: Text('My Wallet', style: CustomAppTheme.actionBarText),
          ),
          body: Column(
            children: [
              Visibility(
                visible: !isWalletCreated,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                  child: LoginBtn("Create Wallet", () {
                    createWallet(context);
                  }, CustomAppTheme.btnWhiteText),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: GestureDetector(
                        onTap: () {
                          openWallet(
                              list[i]['address'].toString(),
                              list[i]['balance'].toString(),
                              list[i]['name'].toString(),
                              list[i]['walletHolder'].toString(),
                              list[i]['id'].toString(),
                              list[i]['spendKey'].toString(),
                              list[i]['viewKey'].toString());
                        },
                        child: WalletCard(
                            list[i]['name'].toString(),
                            '${double.parse(list[i]['balance'].toString()).toStringAsFixed(6)} XUNI',
                            parseTime(list[i]['updatedAt'].toString()))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  openWallet(String address, String balance, String name, String walletHolder,
      String id, String spendKey, String viewKey) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WalletScreen(
                address, balance, name, walletHolder, id, spendKey, viewKey))).then((value) => getWallets());
  }

  createWallet(BuildContext context) {
    print('create wallet');
    customDialog(context);
  }

  customDialog(BuildContext context) {
    TextEditingController walletNameController = TextEditingController();

    var walletDialog = Align(
      alignment: Alignment(0, -1),
      child: Material(
        color: Color(0xffffff),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          margin:EdgeInsets.only(top: 100) ,
          width: 350,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
               width: double.infinity,
                child: Text(
                  'Wallet name',
                  style: CustomAppTheme.btnBlackText,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DialogTextField("Enter wallet name", walletNameController,
                    TextInputType.name, false),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LoginBtn('CREATE WALLET', () {
                  String walletName=walletNameController.text.toString().trim();
                  if(walletName.isEmpty){
                    showSnackBar(context,"Enter wallet name");
                    return;
                  }
                  createWalletAPI(walletName);
                }, CustomAppTheme.btnWhiteText),
              ),
            ],
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return walletDialog;
      },
    );
  }

  createWalletAPI(String name) {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      setState(() {
        _isInAsyncCall = true;
      });
      ApiService.instance.createWallet(cvalue.id,name).then((value) {

        var extractData = json.decode(value.body);

        if(value.statusCode==200){
          showSnackBar(context,extractData['message']);
          Navigator.pop(context, true);

          CurrentUser currentUser =cvalue;
          currentUser.isWalletCreated='true';
          UserLocalStore userLocalStore = new UserLocalStore();
          userLocalStore.storeUserData(currentUser);

          getWallets();

          setState(() {
            isWalletCreated = true;
          });
        }else{
          showSnackBar(context,extractData['message']);
        }
      });
    });
  }
}
