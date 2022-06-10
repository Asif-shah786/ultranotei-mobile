import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultranote_infinity/screen/message/chacha8.dart';
import 'package:ultranote_infinity/screen/message/price_constants.dart';
import 'package:dio/dio.dart' as deo;
import 'package:buffer/buffer.dart';
import 'package:archive/archive_io.dart';
import 'dart:developer';
import 'package:convert/convert.dart';
import 'package:http/http.dart';
import 'package:ultranote_infinity/utils/utils.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  bool loadData = false;
  String replyAddress = '';
  double totalbits = 0;
  double fileHeight = 0.0;
  int anonymity = 2;
  bool selfDistruct = false;
  int messageLength = 0;
  double percentage = 0.0;
  double barpercentag = 0.0;
  double total = 0.0;
  var encoder = ZipFileEncoder();
  List<TextEditingController> resipentList = [];
  List<FilePickerResult> filesList = [];
  List<int> lengthList = [];
  List<String> fileNameList = [];
  List<deo.MultipartFile> formdataList = [];
  // List<TextEditingController> filesNameList = [];
  File? testingImage;

  loadDataScreen(bool value) {
    loadData = value;
    update();
  }

  clearData() {
    filesList.clear();
    resipentList.clear();
    formdataList.clear();

    total = 0.0;
    percentage = 0.0;
    print("------------khkdfhshfds----------");
    print('clear list');
    update();
    print('clear list${filesList.length}');
  }

  addFile(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      if (result.files.single.size > PriceConstant.MAX_ATTACHMENT_SIZE) {
        showSnackBar(context, "Attachment size is too large");
      } else if (total + result.files.single.size >
          PriceConstant.MAX_ATTACHMENT_SIZE) {
        showSnackBar(context, "Attachments size cannot exceed 100MB");
      } else {
        if (filesList.isEmpty) {
          fileHeight = 0.0;
          fileHeight = fileHeight + 120;
        } else {
          fileHeight = fileHeight + 64.0;
        }

        filesList.add(result);
        var value = await deo.MultipartFile.fromFile(file.path,
            filename: basename(file.path));
        formdataList.add(value);
        // fileNameList.add(result.files.single.name);
        // print('file length length=${result.files.single.size}');
        // lengthList.add(result.files.single.size);
      }
    } else {
      // User canceled the picker
    }
    // print('formated dataList length=${formdataList.length}');
    // print('name List length=${fileNameList.length}');
    // print('size dataList length=${lengthList.length}');
    print('filesList List length=${filesList.length}');
    update();
    calcPercentage(filesList);
    calcAmount();
  }

  calcPercentage(List<FilePickerResult> list) {
    total = 0.0;
    for (int i = 0; i < list.length; i++) {
      total = total + list[i].files.single.size;
    }

    var v = total / 104857600;
    percentage = v * 100;
    barpercentag = percentage / 100;
    update();
  }

  removeFile(int index) {
    // print('formated dataList length=${formdataList.length}');
    // print('name List length=${fileNameList.length}');
    // print('size dataList length=${lengthList.length}');
    // print('filesList List length=${filesList.length}');
    // print('index that delete =$index');
    // lengthList.removeAt(index);
    // fileNameList.removeAt(index);
    filesList.removeAt(index);
    fileHeight = fileHeight - 64.0;
    update();
    calcPercentage(filesList);
    calcAmount();
  }

  addResipent() {
    resipentList.add(TextEditingController());
    update();
    calcAmount();
  }

  removeResipent(int index) {
    resipentList.removeAt(index);
    update();
    calcAmount();
  }

  updateTextPrice(int textLength) {
    messageLength = textLength;
    update();
    calcAmount();
  }

  changeSelfDistruct(bool value) {
    selfDistruct = value;
    update();
    calcAmount();
  }

  calcAmount() {
    totalbits = 0;
    // fee for permanent message
    if (selfDistruct == false) totalbits += PriceConstant.MINIMAL_MESSAGE_FEE;
    // fee for attachment
    if (filesList.length > 0)
      totalbits += (total / (1024 * 1024)) * PriceConstant.ATTACHMENT_PRICE;
    // fee for anonymity
    if (anonymity > 2) totalbits += anonymity * PriceConstant.ANONYMITY_PRICE;
    // fee for recipients
    totalbits += PriceConstant.MESSAGE_AMOUNT * resipentList.length;
    totalbits += PriceConstant.MESSAGE_CHAR_PRICE * messageLength;
    update();
    print('yyy$totalbits');
  }

  Future<dynamic> SendMsg(
    List<TextEditingController> address,
    String id,
    bool reply,
    bool self,
    int selfTime,
    String msg,
    double amount,
    int anonmity,
  ) async {
    print(formdataList.length);
    for (int i = 0; i < address.length; i++) {
      try {
        var mapObj = {
          'files': formdataList,
          "id": id,
          "addresses": jsonEncode([address[i].text]),
          "replyTo": reply,
          "selfDestructTime": self,
          "destructTime": selfTime,
          "message": msg.replaceAll("&nbsp;", " "),
          "amount": amount.toPrecision(6),
          "anonymity": anonymity
        };

        deo.FormData data = deo.FormData.fromMap(mapObj);

        deo.Dio _dio = deo.Dio();
        var response = await _dio.post(
            "https://cloud.ultranote.org/api/wallets/sendmsg",
            data: data);

        if (response.statusCode == 200) {
          print("Response status Cose ${response.statusCode}");
          if (response.data != null) {
            print(".................${response.data}........");
          }
        }
        return response.data;
      } catch (e) {
        print("Exception = ${e}");
      }
    }
  }

  clearReplyData() {
    replyAddress = '';
    update();
  }

  addReplyAddress(String address) {
    replyAddress = address;
    update();
  }
}
