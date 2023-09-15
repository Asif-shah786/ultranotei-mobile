import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';

class SocketService {
  static late IO.Socket socket;
  static connect() {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((value) {
      var socketConnectionOptions = {
        "extraHeaders": {"Authorization": "Bearer ${value.token}"}
      };
      print(socketConnectionOptions);
      IO.OptionBuilder builder = new OptionBuilder();
      try {
        socket = IO.io(
            'https://cloud.ultranote.org',
            builder.setPath("/api/socket").disableAutoConnect().setExtraHeaders(
                {"Authorization": "Bearer ${value.token}"}).build());
        socket.connect();
        Future.delayed(Duration(seconds: 5), () {
          print("hello socket " + socket.id.toString());
        });
        print("hello socket " + socket.connected.toString());
      } catch (e) {
        print('hello socket' + e.toString());
      }
    });
  }

  static disconnect() {
    socket.disconnect();
  }

  static OnConnect(dynamic Function(dynamic) handler) {
    try {
      socket.onConnect(handler);
    } catch (e) {
      print("socket exception " + e.toString());
    }
  }

  static onDisconnect(dynamic Function(dynamic) handler) {
    socket.onDisconnect(handler);
  }

  static on(String eventName, dynamic Function(dynamic) handler) {
    socket.on(eventName, handler);
  }

  static emit(String eventName, dynamic data) {
    socket.emit(eventName, data);
  }
}
