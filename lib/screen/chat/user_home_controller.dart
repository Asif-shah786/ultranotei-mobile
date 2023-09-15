import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/chat/user_msg_model.dart';
import 'package:ultranote_infinity/screen/chat/users_model.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/service/socket_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:uuid/uuid.dart';

class UserChatController extends GetxController {
  static UserChatController get to => Get.find();
  TextEditingController updateController = TextEditingController();
  List<UserModel> allActiveUsers = [];
  List<UserMsgModel> allChatMsgs = [];
  UserAllChatMsgs? userAllMsgs;
  Future<CurrentUser>? cUSer;
  String? userId;
  String? userFullName;
  bool? isMuted = false;
  bool? isAdmin = false;

  clearData() {
    allActiveUsers = [];
    allChatMsgs = [];
    update();
  }

  getLoginUser() {
    UserLocalStore userLocalStore = new UserLocalStore();
    userLocalStore.getLoggedInUser().then((value) {
      userId = value.id;
      userFullName = ("${value.firstName} ${value.lastName}").trim();
      update();
    });
  }

  reciveChatRoomMsg() {
    SocketService.on("ReceiveChatRoomMessage", (result) {
      print("Msg Function");
      print(result);

      userAllMsgs!.messages!.add(UserMsgModel.fromMap(result));
      update();
    });
  }

  getOnlineUsers() {
    print("get online users");
    SocketService.on("ReceiveOnlineUser", (result) {
      print("Online user====");
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
        allActiveUsers.removeWhere((it) => it.userId == model!.userId);
        allActiveUsers.add(model);
        print("clear method call ${allActiveUsers.length}");
        update();
      }
    });
    SocketService.emit("GetAllUser", {});
  }

  reciverRemoveUser() {
    SocketService.on("ReceiveRemoveUser", (result) {
      print("remove user");
      print(result);

      allActiveUsers.removeWhere((element) => element.userId == result);
      update();
    });
  }

  MuteUser(String id, String status, int index) {
    Map<String, dynamic> map = {"muteStatus": status, "userId": id};

    SocketService.emit('ChangeMuteStatus', map);
    if (status == "mute") {
      allActiveUsers[index].IsMuted = true;
    } else {
      allActiveUsers[index].IsMuted = false;
    }
    update();
  }

  reciverDeletedMsgs() {
    SocketService.on("ReceiveDeleteMessage", (result) {
      print("delete msg");
      print(result);

      userAllMsgs!.messages!.removeWhere((element) => element.msgId == result);
      update();
    });
  }

  reciverUpdateMsgs() {
    SocketService.on("ReceiveUpdateMessage", (result) {
      print("updtae msg");
      print(result);
      Map<String, String> updatemsg = jsonDecode(result);

      userAllMsgs = userAllMsgs!.messages!.map((m) {
        if (m.msgId == updatemsg["msgId"]) {
          m.isEdited = true;
          m.message = updatemsg["msg"];
        }
        return m;
      }) as UserAllChatMsgs;
      update();
    });
  }

  reciverMuteStatus() {
    SocketService.on("ReceiveMuteStatus", (result) {
      print("mute status user");
      print(result);

      isMuted = result;
      update();
    });
  }

  getChatMsgs() {
    ApiService.instance.getChatMessages().then((value) {
      print("get All Chat mssgs");
      print(value);

      userAllMsgs = UserAllChatMsgs.fromMap(value);
      isMuted = userAllMsgs!.IsMuted;
      isAdmin = userAllMsgs!.IsAdmin;
      update();
    });
  }

  sendMsg(String type, String msg) {
    print("------");
    String msgID = Uuid().v4();
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    var data = {"msgId": msgID, "type": type, "message": msg, "time": time};
    SocketService.emit('SendChatRoomMessage', jsonEncode(data));

    UserMsgModel model = UserMsgModel(
        isEdited: false,
        message: msg,
        msgId: msgID,
        msgType: "text",
        time: time,
        name: userFullName,
        userId: userId,
        picture: null);
    userAllMsgs!.messages!.add(model);
    update();
  }

  deleteMsg(String MsgID) {
    SocketService.emit("DeleteMessage", MsgID);

    userAllMsgs!.messages!.removeWhere((element) => element.msgId == MsgID);
    update();
  }

  updateMsg(String msg, String id, int index) {
    var newmsg = {"msg": msg, "msgId": id};
    SocketService.emit("UpdateMessage", newmsg);
    userAllMsgs!.messages![index].message = msg;

    // userAllMsgs = userAllMsgs!.messages!.map((m) {
    //   if (m.msgId == id) {
    //     m.isEdited = true;
    //     m.message = msg;
    //   }
    //   return m;
    // }) as UserAllChatMsgs;
    update();
  }
}
