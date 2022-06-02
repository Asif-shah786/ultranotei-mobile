import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/contacts/contact_controller.dart';
import 'package:ultranote_infinity/screen/message/msg_controler.dart';
import 'package:ultranote_infinity/screen/message/wallet_model.dart';
import 'package:ultranote_infinity/screen/scan_qr_code_screen.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:path/path.dart';

class SendMessageScreen extends StatefulWidget {
  const SendMessageScreen({Key? key}) : super(key: key);

  @override
  State<SendMessageScreen> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  var height, width;
  String userId = '';
  String senderAddress = '';
  bool loading = true;
  int anonmityValue = 2;
  int destructTime = 0;
  String msg = '';
  double resipentHeight = 64.0;
  bool rangeCheck = false;
  bool addReplyvalue = false;
  bool selfValue = false;
  List walletlist = [];
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  HtmlEditorController controller = HtmlEditorController();
  TextEditingController addressController = TextEditingController();
  TextEditingController destructTimeController = TextEditingController();
  TextEditingController anonmityController = TextEditingController();
  List<TextEditingController> resipentList = [];
  late wallletModel walletModel;

  @override
  void initState() {
    MessageController.to.clearData();
    MessageController.to.clearReplyData();
    getUserDetail();
    loadingScreen();
    if (MessageController.to.resipentList.isEmpty) {
      MessageController.to.addResipent();
      MessageController.to.calcAmount();
      if (MessageController.to.replyAddress != '') {
        setState(() {
          MessageController.to.resipentList[0].text =
              MessageController.to.replyAddress;
        });
      }
    }

    super.initState();
  }

  loadingScreen() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  getUserDetail() {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      setState(() {
        userId = cvalue.id;

        print('user id $userId');
        ApiService.instance.mywallet(cvalue.id).then((value) {
          setState(() {
            walletlist = value[0];
            senderAddress = walletlist[0]['address'].toString();
            walletModel = wallletModel(
                address: walletlist[0]['address'].toString(),
                balance: walletlist[0]['balance'].toString(),
                createdAt: walletlist[0]['createdAt'].toString(),
                id: walletlist[0]['id'].toString(),
                name: walletlist[0]['name'].toString(),
                spendKey: walletlist[0]['spendKey'].toString(),
                walletHolder: walletlist[0]['walletHolder'].toString(),
                viewKey: walletlist[0]['viewKey'].toString(),
                updatedAt: walletlist[0]['updatedAt'].toString());

            print(walletlist.length);
          });
        });
      });
    });
  }

  @override
  void dispose() {
    destructTimeController.dispose();
    super.dispose();
  }

  incrementAnonmity() {
    if (anonmityValue < 10) {
      setState(() {
        anonmityValue++;
      });
    }
  }

  decrementAnonmity() {
    if (anonmityValue > 0) {
      setState(() {
        anonmityValue--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GetBuilder<MessageController>(builder: (msgObj) {
        return InkWell(
          onTap: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back/loginpage_back.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    height: height * 0.07,
                    width: width,
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Send Message',
                      style: CustomAppTheme.smallWhiteText,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: resipentHeight,
                    width: width,
                    child: ListView.builder(
                      itemCount: msgObj.resipentList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: height * 0.07,
                              width: width,
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: msgObj.resipentList[index],
                                    keyboardType: TextInputType.name,
                                    style: CustomAppTheme.inputText,
                                    validator: (Value) {
                                      if (Value == null || Value.isEmpty) {
                                        return 'Address is required';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      isDense: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'Send To',
                                      hintStyle: CustomAppTheme.inputHint2Text,
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  )),
                                  ContactController.to.allContactList.isEmpty
                                      ? Container()
                                      : IconButton(
                                          padding: EdgeInsets.all(4),
                                          onPressed: () {
                                            selectAddress(context, index);
                                          },
                                          icon: Icon(Icons.book),
                                          color: Colors.white,
                                        ),
                                  IconButton(
                                    padding: EdgeInsets.all(4),
                                    onPressed: () {
                                      FlutterClipboard.paste().then((value) {
                                        setState(() {
                                          msgObj.resipentList[index].text =
                                              value;
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.paste),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.all(4),
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        Navigator.of(context)
                                            .push(
                                              new MaterialPageRoute(
                                                  builder: (_) =>
                                                      new ScanQRCodeScreen()),
                                            )
                                            .then((val) =>
                                                val ? setAddress(index) : null);
                                      });
                                    },
                                    icon: Icon(Icons.qr_code),
                                    color: Colors.white,
                                  ),
                                  index != 0
                                      ? IconButton(
                                          padding: EdgeInsets.all(4),
                                          onPressed: () {
                                            MessageController.to
                                                .removeResipent(index);
                                            setState(() {
                                              resipentHeight =
                                                  resipentHeight - height * 0.1;
                                            });
                                          },
                                          icon: Icon(Icons.remove_circle),
                                          color: Colors.white,
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    width: width,
                    height: height * 0.35,
                    child: loading == true
                        ? Center(child: CircularProgressIndicator())
                        : HtmlEditor(
                            callbacks: Callbacks(
                              onChangeContent: (p) {
                                controller.getText().then((value) {
                                  setState(() {
                                    msg = value;
                                  });
                                  print('yyy$value');
                                  print('yyy${value.length}');
                                  MessageController.to
                                      .updateTextPrice(value.length);
                                });
                              },
                            ),
                            controller: controller, //required
                            htmlToolbarOptions: HtmlToolbarOptions(
                                dropdownMenuMaxHeight: height * 0.2,
                                textStyle: TextStyle(color: Colors.white),
                                buttonColor: Colors.white,
                                dropdownIconColor: Colors.white,
                                dropdownBackgroundColor:
                                    CustomAppTheme.purple_tab,
                                toolbarType: ToolbarType.nativeScrollable),

                            htmlEditorOptions: HtmlEditorOptions(
                              inputType: HtmlInputType.text,
                              hint: "Your text Message here...",
                              //initalText: "text content initial, if any",
                            ),
                          ),
                  ),
                  // msgObj.filesList.isEmpty
                  msgObj.filesList.isEmpty
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(top: height * 0.03),
                          child: Container(
                            height: msgObj.fileHeight,
                            width: width,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: height,
                                    width: width,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: msgObj.filesList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.02),
                                          child: Container(
                                              height: height * 0.07,
                                              width: width,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3)),
                                                    height: height,
                                                    width: width,
                                                    child: TextFormField(
                                                      textAlign: TextAlign.left,
                                                      decoration: InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          isDense: true,
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              '${msgObj.filesList[index].files.single.name}',
                                                          hintStyle: CustomAppTheme
                                                              .smallWhiteText),
                                                    ),
                                                  )),
                                                  SizedBox(
                                                    width: width * 0.03,
                                                  ),
                                                  IconButton(
                                                    padding: EdgeInsets.all(4),
                                                    onPressed: () {
                                                      msgObj.removeFile(index);
                                                    },
                                                    icon: Icon(
                                                        Icons.remove_circle),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.07,
                                  width: width,
                                  child: Column(
                                    children: [
                                      LinearPercentIndicator(
                                        animateFromLastPercent: true,
                                        animation: true,
                                        width: width * 0.9,
                                        lineHeight: height * 0.025,
                                        percent: msgObj.barpercentag,
                                        backgroundColor: Colors.grey,
                                        progressColor:
                                            CustomAppTheme.purple_tab,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: height,
                                          width: width,
                                          child: Center(
                                              child: Text(
                                                  'Used ${msgObj.percentage.toStringAsFixed(2)} MB of 100.00 MB ${msgObj.percentage.toStringAsFixed(2)}%',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * 0.025,
                                                  ))),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                  Container(
                    height: height * 0.07,
                    width: width,
                    child: Row(
                      children: [
                        Checkbox(
                            side: BorderSide(color: Colors.white),
                            focusColor: Colors.white,
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: addReplyvalue,
                            onChanged: (v) {
                              setState(() {
                                addReplyvalue = v!;
                              });
                            }),
                        Text(
                          'Add "Reply To"',
                          style: CustomAppTheme.smallWhiteText,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.07,
                    width: width,
                    child: Row(
                      children: [
                        Checkbox(
                            side: BorderSide(color: Colors.white),
                            focusColor: Colors.white,
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: selfValue,
                            onChanged: (v) {
                              setState(() {
                                selfValue = v!;
                                print(v);

                                MessageController.to.changeSelfDistruct(v);
                                destructTimeController.clear();
                              });
                            }),
                        Text(
                          'Set self destruct time',
                          style: CustomAppTheme.smallWhiteText,
                        )
                      ],
                    ),
                  ),
                  selfValue == true
                      ? Padding(
                          padding: EdgeInsets.only(right: width * 0.2),
                          child: Container(
                            height: rangeCheck == true
                                ? height * 0.12
                                : height * 0.07,
                            width: width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: height * 0.07,
                                  width: width,
                                  child: TextField(
                                    controller: destructTimeController,
                                    keyboardType: TextInputType.phone,
                                    onChanged: (dv) {
                                      destructTime = int.parse(dv);

                                      if (destructTime < 300) {
                                        print('eee');
                                        setState(() {
                                          rangeCheck = true;
                                        });
                                      } else if (destructTime > 50400) {
                                        print('eee');
                                        setState(() {
                                          rangeCheck = true;
                                        });
                                      } else {
                                        setState(() {
                                          rangeCheck = false;
                                        });
                                      }
                                    },
                                    style: CustomAppTheme.inputText,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      isDense: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'Destruct Time',
                                      hintStyle: CustomAppTheme.inputHint2Text,
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                rangeCheck == true
                                    ? Text(
                                        'Self destruct time must be between 5 minutes and 14 hours',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    'Anonymity Level',
                    style: CustomAppTheme.smallWhiteText,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width * 0.5),
                    child: Container(
                      height: height * 0.07,
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: height,
                              width: width,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: width * 0.03),
                                child: Text(
                                  '$anonmityValue',
                                  style: CustomAppTheme.inputHint2Text,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: height,
                            width: width * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    incrementAnonmity();
                                  },
                                  child: Container(
                                    height: height,
                                    width: width,
                                    child: Icon(Icons.arrow_drop_up_sharp),
                                  ),
                                )),
                                Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          decrementAnonmity();
                                        },
                                        child: Container(
                                            height: height,
                                            width: width,
                                            child: Icon(
                                                Icons.arrow_drop_down_sharp))))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    'Fee',
                    style: CustomAppTheme.smallWhiteText,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width * 0.1),
                    child: GetBuilder<MessageController>(builder: (msgObj) {
                      return Container(
                          height: height * 0.07,
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 0.02),
                            child: Text(
                              '${(msgObj.totalbits / 1000000).toStringAsFixed(6)} XUNI (${msgObj.totalbits} bits)',
                            ),
                          ));
                    }),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                      height: height * 0.1,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              MessageController.to.addResipent();
                              setState(() {
                                resipentHeight = resipentHeight + height * 0.1;
                              });
                            },
                            child: Container(
                              height: height * 0.07,
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                  child: Text('ADD RECIPIENT',
                                      style: CustomAppTheme.btnTextStyle)),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          InkWell(
                            onTap: () {
                              MessageController.to.addFile(context);
                            },
                            child: Container(
                              height: height * 0.07,
                              width: width * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                  child: Text('ADD ATTACHMENT',
                                      textAlign: TextAlign.center,
                                      style: CustomAppTheme.btnTextStyle)),
                            ),
                          )
                        ],
                      )),
                  InkWell(
                    onTap: () {
                      if (msgObj.resipentList[0].text.isEmpty) {
                        showSnackBar(context, "Resipent Address is Required");
                      } else {
                        msgObj.SendMsg(
                          msgObj.resipentList,
                          userId,
                          addReplyvalue,
                          selfValue,
                          destructTime,
                          msg,
                          msgObj.totalbits,
                          anonmityValue,
                        ).then((value) {
                          print('return Value');
                          print(value.toString());
                          showSnackBar(context, value['message']);
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/homescreen', (Route<dynamic> route) => false);
                          });

                          // DefaultTabController.of(context)!.animateTo(0);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => WalletTab(),
                          //     ));
                        });
                      }
                    },
                    child: Container(
                      height: height * 0.1,
                      width: width,
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3)),
                        child: Center(
                            child: Text('SEND',
                                style: CustomAppTheme.btnTextStyle)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.2,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  selectAddress(BuildContext context, int index) {
    print('add address');
    customDialog(context, index);
  }

  customDialog(BuildContext context, int resIndex) {
    TextEditingController labelController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    var walletDialog = Align(
      alignment: Alignment(0, -1),
      child: Material(
        color: Color(0xffffff),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          margin: EdgeInsets.only(
            top: 50,
          ),
          width: 350,
          height: height * 0.6,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/back/loginpage_back.png"),
              fit: BoxFit.cover,
            ),
            // color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: height * 0.07,
                width: width,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: height,
                        width: width,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: width * 0.05),
                        child: Text(
                          'Select Address',
                          style: CustomAppTheme.smallWhiteBoldText,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: Container(
                  height: height,
                  width: width,
                  child: ListView.builder(
                    itemCount: ContactController.to.allContactList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: height * 0.09,
                            width: width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ContactController.to.allContactList[index].label}',
                                  style: CustomAppTheme.smallWhiteBoldText,
                                ),
                                Expanded(
                                  child: Text(
                                    '${ContactController.to.allContactList[index].address}',
                                    style: CustomAppTheme.smallGreyText,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: height * 0.05,
                            width: width,
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  MessageController
                                          .to.resipentList[resIndex].text =
                                      ContactController
                                          .to.allContactList[index].address;
                                });
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.send_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                          )
                        ],
                      );
                    },
                  ),
                ),
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

  setAddress(int index) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String address = sp.getString('address')!;
    print(address);
    setState(() {
      // addressController.text = address;
      MessageController.to.resipentList[index].text = address;
    });
  }
}
