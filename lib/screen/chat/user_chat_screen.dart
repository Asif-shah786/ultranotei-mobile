import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/chat/chat_bubble.dart';
import 'package:ultranote_infinity/screen/chat/user_msg_model.dart';
import 'package:ultranote_infinity/screen/chat/users_model.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/service/socket_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:uuid/uuid.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;
  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  Animation<double>? topBarAnimation;
  var height, width;
  List<UserModel> allActiveUsers = [];
  List<UserMsgModel> allChatMsgs = [];
  UserAllChatMsgs? userAllMsgs;
  Future<CurrentUser>? cUSer;
  String? userId;
  String? userFullName;
  bool? isMuted = false;
  TextEditingController msgController = TextEditingController();
  FocusNode focusNode = FocusNode();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool show = false;
  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    UserLocalStore userLocalStore = new UserLocalStore();
    userLocalStore.getLoggedInUser().then((value) {
      setState(() {
        userId = value.id;
        userFullName = ("${value.firstName} ${value.lastName}").trim();
      });
    });
    SocketService.on("ReceiveChatRoomMessage", (result) {
      print("Msg Function");
      print(result);

      setState(() {
        userAllMsgs!.messages!.add(UserMsgModel.fromMap(result));
      });
    });
    SocketService.on("ReceiveOnlineUser", (result) {
      print("Online user");
      // print(result);
      UserModel? model;
      if (result.toString().contains('[')) {
        var a = result as List<dynamic>;
        model = UserModel.fromMap(a[0]);

        print("array");
      } else {
        model = UserModel.fromMap(result);
        print("object");
      }

      if (userId != model.userId) {
        print(model);
        setState(() {
          allActiveUsers.add(model!);
        });
      }
    });
    SocketService.on("ReceiveRemoveUser", (result) {
      print("remove user");
      print(result);
      setState(() {
        allActiveUsers.removeWhere((element) => element.userId == result);
      });
    });
    SocketService.on("ReceiveDeleteMessage", (result) {
      print("delete msg");
      print(result);
      setState(() {
        userAllMsgs!.messages!
            .removeWhere((element) => element.msgId == result);
      });
    });
    SocketService.on("ReceiveUpdateMessage", (result) {
      print("updtae msg");
      print(result);
      Map<String, String> updatemsg = jsonDecode(result);
      setState(() {
        userAllMsgs = userAllMsgs!.messages!.map((m) {
          if (m.msgId == updatemsg["msgId"]) {
            m.isEdited = true;
            m.message = updatemsg["msg"];
          }
          return m;
        }) as UserAllChatMsgs;
      });
    });
    SocketService.on("ReceiveMuteStatus", (result) {
      print("mute status user");
      print(result);
      setState(() {
        isMuted = result;
      });
    });
    SocketService.emit("GetAllUser", {});
    ApiService.instance.getChatMessages().then((value) {
      print("get All Chat mssgs");
      print(value);
      setState(() {
        userAllMsgs = UserAllChatMsgs.fromMap(value);
        isMuted = userAllMsgs!.IsMuted;
      });
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    super.initState();
  }

  sendMsg(String type, String msg) {
    print(msgController.text);
    print("------");
    String msgID = Uuid().v4();
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    var data = {"msgId": msgID, "type": type, "message": msg, "time": time};
    SocketService.emit('SendChatRoomMessage', jsonEncode(data));

    setState(() {
      UserMsgModel model = UserMsgModel(
          isEdited: false,
          message: msgController.text,
          msgId: msgID,
          msgType: "text",
          time: time,
          name: userFullName,
          userId: userId,
          picture: null);
      userAllMsgs!.messages!.add(model);
    });
  }

  picImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
      String base64string =
          'data:image/png;base64,' + base64.encode(imagebytes);
      sendMsg("image", base64string);
    }
  }

  deleteMsg(String MsgID) {
    SocketService.emit("DeleteMessage", MsgID);
    setState(() {
      userAllMsgs!.messages!.removeWhere((element) => element.msgId == MsgID);
    });
  }

  updateMsg(String msg, String id) {
    var newmsg = {"msg": msg, "msgId": id};
    SocketService.emit("UpdateMessage", newmsg);
  }

  String? path;
  XFile? pickedfile;
  Widget iconCreation(
      IconData icons, Color color, String text, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: SizedBox(
        width: width * 0.6,
        child: Drawer(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back/loginpage_back.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  height: height * 0.2,
                  width: width,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      width: 50,
                      height: 50,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icon/ultranote_icon.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height * 0.07,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Active Users",
                        style: CustomAppTheme.settingText,
                      ),
                      Text(
                        "(${allActiveUsers.length})",
                        style: CustomAppTheme.settingText,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height,
                    width: width,
                    child: ListView.builder(
                      itemCount: allActiveUsers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: Container(
                            height: height * 0.09,
                            width: width * 0.2,
                            child: Row(
                              children: [
                                allActiveUsers[index].picture ==
                                    "https://via.placeholder.com/50" ||
                                    allActiveUsers[index].picture == null
                                    ? Container(
                                  height: height * 0.07,
                                  width: width * 0.14,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white
                                              .withOpacity(0.8),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: width * 0.07,
                                      )),
                                )
                                    : Container(
                                  height: height * 0.07,
                                  width: width * 0.14,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(Base64Decoder()
                                              .convert(allActiveUsers[
                                          index]
                                              .picture!
                                              .replaceAll(
                                              "data:image/png;base64,",
                                              "")))),
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  width: width * 0.04,
                                ),
                                Expanded(
                                  child: Container(
                                    height: height,
                                    width: width,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      allActiveUsers[index].name!,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.03),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back/loginpage_back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              child: Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  width: 85,
                  height: 85,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icon/ultranote_icon.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  Container(
                    height: height * 0.1,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Container(
                        //     height: height,
                        //     width: width * 0.15,
                        //     alignment: Alignment.bottomCenter,
                        //     child: Icon(
                        //       Icons.arrow_back_ios,
                        //       color: Colors.white,
                        //       size: width * 0.06,
                        //     )),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Expanded(
                          child: Container(
                            height: height,
                            width: width,
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(left: width * 0.06),
                              child: Text(
                                "Chat",
                                style: CustomAppTheme.settingText,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Container(
                              height: height,
                              width: width * 0.15,
                              alignment: Alignment.bottomCenter,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: width * 0.06,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(
                      height: height,
                      width: width,
                      child: userAllMsgs == null
                          ? Center(child: Text("Loding"))
                          : ListView.builder(
                        itemCount: userAllMsgs!.messages!.length,
                        itemBuilder: (context, index) {
                          return ChatBubble(
                            data: userAllMsgs!.messages![index],
                            receiverid: userId!,
                            size: MediaQuery.of(context).size,
                          );
                          ;
                        },
                      ),
                      // child: Center(
                      //   child: InkWell(
                      //     onTap: () {
                      //       // updateMsg(" update msg from mobile again",
                      //       //     "2c9a9433-b674-49c3-9dd6-2e57b0f6ecbd");
                      //     },
                      //     child: Container(
                      //       height: height * 0.1,
                      //       width: width * 0.2,
                      //       color: Colors.white,
                      //       child: Center(
                      //           child: userAllMsgs != null
                      //               ? Text("${userAllMsgs!.messages!.length}")
                      //               : Text("loding")),
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  isMuted == true
                      ? SizedBox(
                    height: height * 0.07,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Card(
                              margin: const EdgeInsets.only(
                                  left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextFormField(
                                controller: msgController,
                                focusNode: focusNode,
                                cursorColor: Colors.purple,
                                textAlignVertical:
                                TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                minLines: 1,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle:
                                  const TextStyle(color: Colors.grey),
                                  prefixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.keyboard,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      if (!show) {
                                        focusNode.unfocus();
                                        focusNode.canRequestFocus = false;
                                      }
                                      setState(() {
                                        show = !show;
                                      });
                                    },
                                  ),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.attach_file,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                            right: 2,
                            left: 2,
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: IconButton(
                                icon: const Icon(Icons.send,
                                    color: Colors.grey),
                                onPressed: () {}),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        )
                      ],
                    ),
                  )
                      : SizedBox(
                    height: height * 0.07,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Card(
                              margin: const EdgeInsets.only(
                                  left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextFormField(
                                controller: msgController,
                                focusNode: focusNode,
                                cursorColor: Colors.purple,
                                textAlignVertical:
                                TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                minLines: 1,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle:
                                  const TextStyle(color: Colors.grey),
                                  prefixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.keyboard,
                                      color: Colors.purple,
                                    ),
                                    onPressed: () {
                                      if (!show) {
                                        focusNode.unfocus();
                                        focusNode.canRequestFocus = false;
                                      }
                                      setState(() {
                                        show = !show;
                                      });
                                    },
                                  ),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.attach_file,
                                          color: Colors.purple,
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              backgroundColor:
                                              Colors.transparent,
                                              context: context,
                                              builder:
                                                  (builder) => SizedBox(
                                                height: 170,
                                                width:
                                                MediaQuery.of(
                                                    context)
                                                    .size
                                                    .width,
                                                child: Card(
                                                  margin:
                                                  const EdgeInsets
                                                      .all(
                                                      18.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        20),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            iconCreation(
                                                              Icons.camera_alt,
                                                              Colors.pink,
                                                              "Camera",
                                                                  () async {
                                                                print("object");
                                                                XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                                                                if (pickedImage != null) {
                                                                  File imageFile = File(pickedImage.path);
                                                                  Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
                                                                  String base64string = 'data:image/png;base64,' + base64.encode(imagebytes);
                                                                  sendMsg("image", base64string);
                                                                }
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                width: 40),
                                                            iconCreation(
                                                              Icons.insert_photo,
                                                              Colors.purple,
                                                              "Gallery",
                                                                  () async {
                                                                print("object");
                                                                XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                                                                if (pickedImage != null) {
                                                                  File imageFile = File(pickedImage.path);
                                                                  Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
                                                                  String base64string = 'data:image/png;base64,' + base64.encode(imagebytes);
                                                                  sendMsg("image", base64string);
                                                                }
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ));
                                        },
                                      ),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                            right: 2,
                            left: 2,
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: IconButton(
                                icon: const Icon(Icons.send,
                                    color: Colors.purple),
                                onPressed: () {
                                  if (msgController.text
                                      .trim()
                                      .isNotEmpty) {
                                    sendMsg("text", msgController.text);
                                    msgController.clear();
                                  }
                                }),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.09,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
