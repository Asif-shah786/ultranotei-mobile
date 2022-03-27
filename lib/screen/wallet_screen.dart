import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:ultranote_infinity/screen/wallet/history_screen.dart';
import 'package:ultranote_infinity/screen/wallet/receive_screen.dart';
import 'package:ultranote_infinity/screen/wallet/send_screen.dart';

import '../app_theme.dart';

class WalletScreen extends StatefulWidget {

  String ADDRESS;
  String BALANCE;
  String NAME;
  String WALLETHOLDER;
  String ID;
  String SPENDKEY;
  String VIEWKEY;


  WalletScreen(this.ADDRESS, this.BALANCE, this.NAME, this.WALLETHOLDER,
      this.ID, this.SPENDKEY, this.VIEWKEY);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with TickerProviderStateMixin {

  String address='';
  String balance='';
  String name='';
  String walletHolder='';
  String id='';
  String spendKey='';
  String viewKey='';

  @override
  void initState() {

    address=widget.ADDRESS;
    balance=widget.BALANCE;
    name=widget.NAME;
    walletHolder=widget.WALLETHOLDER;
    id=widget.ID;
    spendKey=widget.SPENDKEY;
    viewKey=widget.VIEWKEY;

    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/back/loginpage_back.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: CustomAppTheme.black_bar,
          elevation: 0,
          centerTitle: true,
          title: Text('My Wallet', style: CustomAppTheme.actionBarText),
        ),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: 40,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Container(
                padding: new EdgeInsets.fromLTRB(0, 5, 0, 0),
                color: CustomAppTheme.purple_tab,
                child: TabBar(
                  indicatorSize:TabBarIndicatorSize.tab,
                  indicatorColor:CustomAppTheme.skyBlue ,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: CustomAppTheme.skyBlue , width: 3.0),
                    insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  ),
                  labelColor: CustomAppTheme.skyBlue,
                  unselectedLabelColor: Colors.white,

                  tabs: [
                    Tab(
                      child: Text(
                        "Send",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Receive",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "History",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: CustomAppTheme.purple_tab,
            ),
            body: TabBarView(
              children: [
                SendScreen(address,balance),
                ReceiveScreen(address,spendKey,viewKey,balance),
                HistoryScreen(address),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
