import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:ultranote_infinity/screen/wallet/history_screen.dart';
import 'package:ultranote_infinity/screen/wallet/receive_screen.dart';
import 'package:ultranote_infinity/screen/wallet/send_screen.dart';

import '../../app_theme.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _WalletTabState createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];

  final ScrollController scrollController = ScrollController();

  double topBarOpacity = 0.0;

  @override
  void initState() {
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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 62),
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
                SendScreen(),
                ReceiveScreen(),
                HistoryScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
