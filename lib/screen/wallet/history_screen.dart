import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/dropdowncustom.dart';
import 'package:ultranote_infinity/widget/history_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatefulWidget {

  String ADDRESS;


  HistoryScreen(this.ADDRESS);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin<HistoryScreen> {
  @override
  bool get wantKeepAlive => true;

  String selectedValue = 'Item 1';

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  bool _isInAsyncCall = false;
  List list=[];
  String address='';

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
    // TODO: implement initState
    address=widget.ADDRESS;
    getTransactions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isInAsyncCall,
      child: Column(children: [
        /*Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: CustomAppTheme.purple_tab,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5.0,
                  offset: Offset(0.0, 1.75))
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: DropDownCustom(selectedValue, items, (_) {
            onChange(_);
          }),
        ),*/
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
      ]),
    );
  }

  onChange(String value) {
    print(value);
    setState(() {
      selectedValue = value;
    });
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
