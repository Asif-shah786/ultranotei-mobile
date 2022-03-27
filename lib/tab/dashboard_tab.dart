import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/dashboard/buy_screen.dart';
import 'package:ultranote_infinity/screen/dashboard/sell_screen.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/buy_card.dart';
import 'package:ultranote_infinity/widget/dashboard_card.dart';
import 'package:ultranote_infinity/widget/history_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _DashboardTabState createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  Animation<double>? topBarAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  String aXUNI = '0';
  String aUSD = '0';
  String uXUNI = '0';
  String uUSD = '0';

  bool _isInAsyncCall = false;
  List list=[];
  String address='';
  bool isWalletCreated=true;


  getWallets() {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      setState(() {
        isWalletCreated=cvalue.isWalletCreated=="true"?true:false;
        if(isWalletCreated){
          _isInAsyncCall = true;
        }

      });

      if(isWalletCreated){
        ApiService.instance.mywallet(cvalue.id).then((value) {
          setState(() {
            aXUNI = value[0][0]['balance'].toString();
            aUSD=value[2].toString();
            uXUNI=value[1].toString();
            uUSD=value[3].toString();
            print(list.length);

            setState(() {
              address=value[0][0]['address'].toString();
              getTransactions();
            });

          });
        });
      }else{

      }

    });
  }

  getTransactions(){
    setState(() {
      _isInAsyncCall=true;
    });
    ApiService.instance.transactions(address).then((value) {

      List depositList=value['deposit'];
      List withdrawList=value['withdraw'];

      print('deposit ${depositList.length.toString()}   withdraw  ${withdrawList.length.toString()} ');

      list.addAll(depositList);
      list.addAll(withdrawList);


      setState(() {


        list.sort((a,b) {
          var adate = a['updatedAt'];
          var bdate = b['updatedAt'];
          return bdate.compareTo(adate);
        });
        print(list.length);
        _isInAsyncCall=false;
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
            title: Text('Dashboard', style: CustomAppTheme.actionBarText),
          ),
          body: Column(
            children: [
              DashboardCard(
                  double.parse(aXUNI).toStringAsFixed(6),
                  double.parse(aUSD).toStringAsFixed(6),
                  double.parse(uXUNI).toStringAsFixed(6),
                  double.parse(uUSD).toStringAsFixed(6)),
              SizedBox(height: 10,),
              Text('Recent Transaction', style: CustomAppTheme.actionBarText),
              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: GestureDetector(
                          onTap: (){
                            openBottomSheet(address==list[i]['senderAdress']?true:false, double.parse((double.parse(list[i]['amount'].toString())/1000000).toString()).toStringAsFixed(6), list[i]['updatedAt'], list[i]['note'],list[i]['hash']);
                          },
                          child: HistoryCard(address==list[i]['senderAdress']?true:false,double.parse((double.parse(list[i]['amount'].toString())/1000000).toString()).toStringAsFixed(6),'Hash : ${list[i]['hash']}',address==list[i]['senderAdress']?'Recipient Address : ${list[i]['recipientAdress']}':'Sender Address : ${list[i]['senderAdress']}',list[i]['updatedAt'])),
                    ),
                  ),
                ),
              )
            ],
          ),

          /*DefaultTabController(
            length: 2,
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
                          "BUY",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "SELL",
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
                  BuyScreen(),
                  SellScreen(),
                ],
              ),
            ),
          ),*/
        ),
      ),
    );
  }

  openBottomSheet(bool isSent,String amount, String time, String desc,String hash) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: CustomAppTheme.cardpurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Transaction Details',style: CustomAppTheme.settingText,textAlign: TextAlign.center,),
                      SizedBox(height: 5,),
                      Text('Do you want to see explorer links?',style: CustomAppTheme.smallWhiteText,),
                      SizedBox(height: 5,),
                      InkWell(
                          onTap: (){
                            openBrowser(hash);
                          },
                          child: Text('View Details',style: CustomAppTheme.smallBlueUnderlineText,)),
                    ],
                  ),
                ),

                SizedBox(height: 10,),
                Container(height: 1,width: double.infinity,color: CustomAppTheme.grey_hint,),
                SizedBox(height: 10,),
                Text(isSent?'Type : Send':'Type : Received',style: CustomAppTheme.botttemSheetText,),
                SizedBox(height: 5,),
                Text('Amount : ${amount} XUNI',style: CustomAppTheme.botttemSheetText,),
                SizedBox(height: 5,),
                Text('Time : ${parseTime(time)}',style: CustomAppTheme.botttemSheetText,),
                SizedBox(height: 5,),
                Text('Description : ${desc}',style: CustomAppTheme.botttemSheetText,),


              ],
            ),
          );
        });
  }

  openBrowser(String hash) async {
    String url ='https://explorer.ultranote.org/index.html?hash=${hash}';
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }

}
