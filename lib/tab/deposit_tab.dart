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
import 'package:ultranote_infinity/widget/deposit_card.dart';
import 'package:ultranote_infinity/widget/history_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

import '../../app_theme.dart';
import '../widget/numeric_input.dart';

class DepositTab extends StatefulWidget {
  const DepositTab({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _DepositTabState createState() => _DepositTabState();
}

class _DepositTabState extends State<DepositTab> {
  bool _isInAsyncCall = true;
  List list = [];
  String address = '';
  bool isWalletCreated = true;
  String userFullName = "User Name";
  double amount = 0;
  int numOfBlocks = 22000;

  postDeposit(BuildContext context) {
    if (amount != 0 || amount != null) {
      UserLocalStore userLocalStore = new UserLocalStore();
      Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
      cUSer.then((cvalue) {
        String id = cvalue.id;
        String sourceAddress = address;
        double amountToDeposit = amount * 1000000;
        int term = numOfBlocks;
        ApiService.instance
            .postDeposit(id, sourceAddress, amountToDeposit, term)
            .then((value) {
          setState(() {
            print(value);
            list = value['res'];
          });
          Navigator.of(context).pop();
        });
      });
    }
  }

  getWallets() async {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      setState(() {
        userFullName = ("${cvalue.firstName} ${cvalue.lastName}").trim();
        isWalletCreated = cvalue.isWalletCreated == "true" ? true : false;
      });

      if (isWalletCreated) {
        ApiService.instance.mywallet(cvalue.id).then((value) {
          setState(() {
            print(list.length);
            setState(() {
              address = value[0][0]['address'].toString();
              getDeposits();
            });
          });
        });
      } else {}
    });
  }

  getDeposits() {
    ApiService.instance.deposits(address).then((value) {
      list = value['res'];
      print('Deposits Response HAseeb${value.toString()}');
      setState(() {
        _isInAsyncCall = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getWallets();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        child: Scaffold(
            backgroundColor: Color.fromARGB(0, 255, 41, 41),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50),
                            primary: CustomAppTheme.black_bar,
                          ),
                          onPressed: () => {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text("Add Deposit"),
                                        content: StatefulBuilder(
                                            // You need this, notice the parameters below:
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                          setNumOfBlocks(value) {
                                            setState(() {
                                              numOfBlocks = value;
                                              print("BLOCKS" +
                                                  numOfBlocks.toString());
                                            });
                                          }

                                          return Container(
                                              child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Amount (XUNI)"),
                                                  Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: TextFormField(
                                                            initialValue: amount
                                                                .toString(),
                                                            onChanged:
                                                                ((value) => {
                                                                      setState(() =>
                                                                          amount =
                                                                              double.parse(value))
                                                                    }),
                                                            keyboardType:
                                                                TextInputType
                                                                    .numberWithOptions(
                                                              decimal: true,
                                                              signed: false,
                                                            ),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'^(\d+)?\.?\d{0,2}')),
                                                              TextInputFormatter
                                                                  .withFunction(
                                                                      (oldValue,
                                                                          newValue) {
                                                                final text =
                                                                    newValue
                                                                        .text;
                                                                return text
                                                                        .isEmpty
                                                                    ? newValue
                                                                    : double.tryParse(text) ==
                                                                            null
                                                                        ? oldValue
                                                                        : newValue;
                                                              }),
                                                            ],
                                                          ))),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 0,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Time (Blocks)"),
                                                  NumericStepButton(
                                                      minValue: 22000,
                                                      counter: numOfBlocks,
                                                      onChanged:
                                                          setNumOfBlocks),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("~ " +
                                                      (numOfBlocks / 22000)
                                                          .ceil()
                                                          .toString() +
                                                      " Months")
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("+ " +
                                                      ((amount *
                                                                  (0.0025 *
                                                                      ((numOfBlocks /
                                                                              22000)
                                                                          .ceil())))
                                                              .toStringAsFixed(
                                                                  4) +
                                                          " XUNI (" +
                                                          (0.25 *
                                                                  ((numOfBlocks /
                                                                          22000)
                                                                      .ceil()))
                                                              .toStringAsFixed(
                                                                  2) +
                                                          "%)"))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      'Deposit Fee 0.010000 XUNI')
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize:
                                                        Size.fromHeight(50),
                                                    primary: CustomAppTheme
                                                        .black_bar,
                                                  ),
                                                  onPressed: (() =>
                                                      postDeposit(context)),
                                                  child: Text('Add Deposit'))
                                            ],
                                          ));
                                        }),
                                      );
                                    })
                              },
                          child: Text('Add Deposit'))),
                ),
                Expanded(
                  flex: 8,
                  child: depositsMade(context),
                ),
              ],
            )));
  }

  Widget depositsMade(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 70),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: ((context, index) {
          // replace this with your actal index uvalue
          bool isWithdrawn = list[index]['isWithdrawn'];
          String dateEx = list[index]['createdAt'];
          DateTime currentDateObj = DateTime.now();
          DateTime createdDateObj = DateTime.parse(list[index]['createdAt']);
          int months = (list[index]['term'] / 22000).ceil();
          print(months);
          // createdDateObj = DateTime(
          //     createdDateObj.year,
          //     createdDateObj.month,
          //     createdDateObj.day,
          //     createdDateObj.hour,
          //     createdDateObj.minute);
          createdDateObj = Jiffy(dateEx).add(months: months).dateTime.toLocal();
          // Updates Year and month respectively
          // createdDateObj.add(Duration(days: equivalentDays));
          int term = (list[index]['term'] / 22000).round();
          double amount = list[index]['amount'].toDouble();
          double unlockPercentage = 0.25 * term / 100;
          double unlockedAmount = amount * (1 + unlockPercentage);
          int blockIndex = (list[index]['blockIndex'] + term).round();
          DateTime? spentDateObj = list[index]['spentAt'] != null
              ? DateTime.parse(list[index]['spentAt'])
              : null;

          String indexCell = (index + 1).toString();
          String statusCell = isWithdrawn
              ? 'Spent'
              : ((currentDateObj.difference(createdDateObj).inMilliseconds >=
                      (term * 3600 * 24 * 30 * 1000)
                  ? 'Unlocked'
                  : 'Locked'));

          String amountCell = '${amount.toStringAsFixed(2)}';

          String quarterCell =
              '${(amount * unlockPercentage).toStringAsFixed(4)}';

          String totalCell = '${unlockedAmount.toStringAsFixed(4)}';

          String percentageCell =
              '${(unlockPercentage * 100).toStringAsFixed(2)} %';
          String blockIndexCell = blockIndex.toString();

          String createdDateCell = createdDateObj != null
              ? '${createdDateObj.year}-${createdDateObj.month.toString().padLeft(2, '0')}-${createdDateObj.day.toString().padLeft(2, '0')} ${createdDateObj.hour.toString().padLeft(2, '0')}:${createdDateObj.minute.toString().padLeft(2, '0')}'
              : '-';

          String spentDateCell = spentDateObj != null
              ? '${spentDateObj.year}-${spentDateObj.month.toString().padLeft(2, '0')}-${spentDateObj.day.toString().padLeft(2, '0')} ${spentDateObj.hour.toString().padLeft(2, '0')}:${spentDateObj.minute.toString().padLeft(2, '0')}'
              : '-';
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: GestureDetector(
                  onTap: () {
                    openBottomSheet(
                        list[index]["id"] ?? "",
                        statusCell,
                        amountCell,
                        quarterCell,
                        totalCell,
                        percentageCell,
                        blockIndexCell,
                        createdDateCell);
                  },
                  child: (DepositCard(
                      list[index]["id"] ?? "",
                      statusCell,
                      amountCell,
                      quarterCell,
                      totalCell,
                      percentageCell,
                      blockIndexCell,
                      createdDateCell))));
        }));
  }

  openBottomSheet(String id, String status, String amount, String interest,
      String sum, String rate, String unlockHeight, String unlockTime) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Deposit Details',
                        style: CustomAppTheme.settingText,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: CustomAppTheme.grey_hint,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  status,
                  style: CustomAppTheme.botttemSheetText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Amount : ${amount} XUNI',
                  style: CustomAppTheme.botttemSheetText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Interest : ${interest}',
                  style: CustomAppTheme.botttemSheetText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Sum : ${sum} XUNI',
                  style: CustomAppTheme.botttemSheetText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Rate : ${rate}',
                  style: CustomAppTheme.botttemSheetText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Unlock Time : ${parseTime(unlockTime)}',
                  style: CustomAppTheme.botttemSheetText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Unlock Height : ${unlockHeight}',
                  style: CustomAppTheme.botttemSheetText,
                ),
              ],
            ),
          );
        });
  }
}
