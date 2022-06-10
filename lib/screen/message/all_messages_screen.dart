import 'dart:developer';
import 'dart:io';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ultranote_infinity/Constants.dart' as Constans;
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart' as deo;
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultranote_infinity/Constants.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/message/message_card.dart';
import 'package:ultranote_infinity/screen/message/get_msglist_model.dart';
import 'package:ultranote_infinity/screen/message/msg_controler.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';

class AllMessagesScreen extends StatefulWidget {
  const AllMessagesScreen({Key? key}) : super(key: key);

  @override
  State<AllMessagesScreen> createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessagesScreen> {
  bool _isInAsyncCall = false;
  List<MsgList>? allMsgs = [];
  getMessages() {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      setState(() {
        _isInAsyncCall = true;
      });
      ApiService.instance.getMessages(cvalue.id).then((value) {
        print(cvalue.id);

        setState(() {
          allMsgs = value.msgList;

          _isInAsyncCall = false;
        });
      });
    });
  }

  @override
  void initState() {
    getMessages();
    Get.put(MessageController());
    super.initState();
  }

  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
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
            padding: EdgeInsets.only(top: height * 0.05, bottom: height * 0.11),
            child: ListView.builder(
              itemCount: allMsgs!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    openBottomSheet(allMsgs![index], context);
                  },
                  child: MessageCard(
                    height: height,
                    model: allMsgs![index],
                    width: width,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  openBottomSheet(MsgList model, BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: CustomAppTheme.cardpurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return GetBuilder<MessageController>(builder: (msgObj) {
            return Container(
              height: height * 0.7,
              width: width,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.05, right: width * 0.05),
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.07,
                          width: width,
                          child: Center(
                              child: Text(
                            'Message Details',
                            style: CustomAppTheme.smallWhiteBoldText,
                          )),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Expanded(
                            child: Container(
                          height: height,
                          width: width,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  height: height,
                                  width: width,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height,
                                        width: width * 0.25,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Block height',
                                          style: CustomAppTheme.smallBlueText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: height,
                                        width: width,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          '${model.blockHeight}',
                                          style:
                                              CustomAppTheme.smallWhiteBoldText,
                                        ),
                                      )),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height,
                                  width: width,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height,
                                        width: width * 0.25,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Transaction Hash',
                                          style: CustomAppTheme.smallBlueText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: height,
                                        width: width,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          '${model.hash}',
                                          style:
                                              CustomAppTheme.smallWhiteBoldText,
                                        ),
                                      )),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height,
                                  width: width,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height,
                                        width: width * 0.25,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Amount',
                                          style: CustomAppTheme.smallBlueText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: height,
                                        alignment: Alignment.topLeft,
                                        width: width,
                                        child: Text(
                                          '${model.amount}',
                                          style:
                                              CustomAppTheme.smallWhiteBoldText,
                                        ),
                                      )),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height,
                                  width: width,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height,
                                        width: width * 0.25,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Type',
                                          style: CustomAppTheme.smallBlueText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: height,
                                        width: width,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          '${model.type}',
                                          style:
                                              CustomAppTheme.smallWhiteBoldText,
                                        ),
                                      )),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height,
                                  width: width,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height,
                                        width: width * 0.25,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Message Body',
                                          style: CustomAppTheme.smallBlueText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: height,
                                        width: width,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          '${model.message}',
                                          style:
                                              CustomAppTheme.smallWhiteBoldText,
                                        ),
                                      )),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          height: height * 0.13,
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              model.headers!.isEmpty
                                  ? Container(
                                      height: height * 0.07,
                                      width: width * 0.25,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        'Reply',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        MessageController.to.clearReplyData();
                                        print(model.headers![0].name);
                                        print(model.headers![0].value);
                                        Navigator.pop(context);
                                        DefaultTabController.of(ctx)!
                                            .animateTo(1);
                                        MessageController.to.addReplyAddress(
                                            model.headers![0].value!);
                                      },
                                      child: Card(
                                        elevation: 5,
                                        shadowColor: CustomAppTheme.skyBlue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: height * 0.07,
                                          width: width * 0.25,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                              child: Text(
                                            'Reply',
                                            style: TextStyle(
                                                color:
                                                    CustomAppTheme.cardpurple,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    ),
                              model.headers!.length > 1
                                  ? InkWell(
                                      onTap: () async {
                                        msgObj.loadDataScreen(true);
                                        ApiService.instance
                                            .downlodAttachment(
                                                model.hash,
                                                model.headers![1].value,
                                                model.headers![2].value)
                                            .then((value) async {
                                          File newfile = File(
                                              "$Staticpath/${model.headers![1].value}.zip");
                                          newfile.writeAsBytes(value);
                                          msgObj.loadDataScreen(false);
                                        });
                                      },
                                      child: Card(
                                        elevation: 5,
                                        shadowColor: CustomAppTheme.skyBlue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: height * 0.07,
                                          width: width * 0.55,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                              child: Text(
                                            'Download Attachment',
                                            style: TextStyle(
                                                color:
                                                    CustomAppTheme.cardpurple,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: height * 0.07,
                                      width: width * 0.55,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        'Download Attachment',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  msgObj.loadData == true
                      ? Container(
                          height: height,
                          width: width,
                          color: Color(0xff6c2589).withOpacity(0.5),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: CustomAppTheme.purple_tab,
                          )),
                        )
                      : SizedBox()
                ],
              ),
            );
          });
        });
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3

    return filePath;
  }
}
