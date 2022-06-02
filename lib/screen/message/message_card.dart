import 'package:flutter/material.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/screen/message/get_msglist_model.dart';

class MessageCard extends StatefulWidget {
  var height, width;
  MsgList? model;
  MessageCard({this.height, this.model, this.width});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.width * 0.03, right: widget.width * 0.03),
      child: Card(
          elevation: 5,
          color: CustomAppTheme.transparentpurple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: widget.height * 0.17,
            width: widget.width * 0.98,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(children: [
                Container(
                  height: widget.height * 0.08,
                  width: widget.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Row(
                    children: [
                      Container(
                        height: widget.height,
                        width: widget.width * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: CustomAppTheme.smallWhiteBoldText,
                            ),
                            Text(
                              '${widget.model!.datetime}',
                              style: CustomAppTheme.smallWhiteText,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: widget.height,
                        width: widget.width * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Height',
                              style: CustomAppTheme.smallWhiteBoldText,
                            ),
                            Text(
                              '${widget.model!.blockHeight}',
                              style: CustomAppTheme.smallWhiteText,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: widget.height,
                        width: widget.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Type',
                              style: CustomAppTheme.smallWhiteBoldText,
                            ),
                            Text(
                              '${widget.model!.type}',
                              style: widget.model!.type == 'OUT'
                                  ? CustomAppTheme.smallPinkBoldText
                                  : CustomAppTheme.smallBlueBoldText,
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: widget.height,
                            width: widget.width,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${widget.model!.message}',
                                style: CustomAppTheme.smallGreyText,
                              ),
                            )),
                      ),
                      Container(
                        height: widget.height,
                        width: widget.width * 0.15,
                        child: Center(
                            child: Icon(
                          Icons.message,
                          color: Colors.white,
                        )),
                      )
                    ],
                  ),
                ))
              ]),
            ),
          )),
    );
  }
}
