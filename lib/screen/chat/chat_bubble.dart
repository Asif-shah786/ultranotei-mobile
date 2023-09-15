// ignore_for_file: must_be_immutable, avoid_print
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ultranote_infinity/screen/chat/user_msg_model.dart';

class ChatBubble extends StatelessWidget {
  Size size;
  UserMsgModel data;
  String receiverid;
  ChatBubble({
    required this.data,
    required this.size,
    required this.receiverid,
  });
  @override
  Widget build(BuildContext context) {
    return data.msgType == "text"
        ? messages(size)
        : data.msgType == "image"
        ? imagecard(context)
        : filebuild(context);
  }

  Widget filebuild(
      BuildContext context,
      ) {
    return Container(
      // alignment: data.userId != receiverid
      //     ? Alignment.centerLeft
      //     : Alignment.centerRight,
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            width: size.width * 0.5,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: data.userId != receiverid
                    ? Colors.purple[900]
                    : Colors.purple),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: data.userId == receiverid ? 7 : 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.insert_drive_file,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "file.${data.message!.split(".").last}",
                          style: TextStyle(
                            fontSize: 16,
                            color: data.userId != receiverid
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (data.userId != receiverid)
                        IconButton(
                          onPressed: () {
                            //   obj.downloadFile(data.message!);
                          },
                          icon: const Icon(
                            Icons.downloading,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: data.userId == receiverid ? 7 : 20,
            right: 15,
            child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: formatDate(data.time!),
                      style: TextStyle(
                        fontSize: 12,
                        color: data.userId != receiverid
                            ? Colors.grey.shade100
                            : Colors.grey.shade400,
                      )),
                  const WidgetSpan(
                      child: SizedBox(
                        width: 3,
                      )),
                  // WidgetSpan(
                  //   child: Icon(
                  //     Icons.done_all,
                  //     size: 20,
                  //     color: data.isRead! ? Colors.green : Colors.grey,
                  //   ),
                  // )
                ])),
          ),
        ],
      ),
    );
  }

  String formatDate(String dateString) {
    var date =
    DateTime.fromMillisecondsSinceEpoch(int.parse(dateString) * 1000);
    String formattedDate = DateFormat('d MMM  hh:mm a').format(date);
    return formattedDate;
  }

  // void _showImageDialog(
  //   BuildContext context,
  // ) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Theme(
  //         data: ThemeData.light(),
  //         child: AlertDialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           title: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               const Text('Download Image'),
  //               InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Icon(Icons.cancel_outlined))
  //             ],
  //           ),
  //           content: SizedBox(
  //             height: MediaQuery.of(context).size.height * 0.4,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 SizedBox(
  //                   height: MediaQuery.of(context).size.height * 0.3,
  //                   child: Image.memory(base64Decode(data.picture!))
  //                 ),
  //                 const SizedBox(height: 20),
  //                 IconButton(
  //                     onPressed: () async {
  //                       final res = await dio.Dio().get(
  //                         StaticVariables.baseurl + data.message!,
  //                         options: dio.Options(
  //                           responseType: dio.ResponseType.bytes,
  //                           followRedirects: false,
  //                         ),
  //                       );

  //                       if (res.statusCode == 200) {
  //                         print(res.headers);
  //                         final rand = Random().nextInt(10000000);

  //                         String fileExtension = data.message!.split(".").last;
  //                         print(res.data);
  //                         // Uint8List bytes = Uint8List.fromList(res.data);
  //                         // List<int> bytes = res.data;

  //                         await FilePickerWritable().openFileForCreate(
  //                             fileName: "$rand.$fileExtension",
  //                             writer: (file) async {
  //                               await file.writeAsBytes(res.data);
  //                             });
  //                       } else {
  //                         print(
  //                             "Request failed with status code: ${res.statusCode}");
  //                       }
  //                     },
  //                     icon: Icon(
  //                       Icons.download_sharp,
  //                       color: AppTheme.primary,
  //                       size: 40,
  //                     ))
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  // //

  Widget imagecard(BuildContext context) {
    return Container(
      // alignment: data.userId != receiverid
      //     ? Alignment.centerLeft
      //     : Alignment.centerRight,
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              // data.isNetwork ? _showImageDialog(context) : null;
            },
            child: Container(
              width: size.width * 0.5,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: data.userId != receiverid
                      ? Colors.purple[900]
                      : Colors.purple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.memory(Base64Decoder().convert(
                      data.message!.replaceAll("data:image/png;base64,", ""))),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: formatDate(data.time!),
                            style: TextStyle(
                              fontSize: 12,
                              color: data.userId == receiverid
                                  ? Colors.purple
                                  : Colors.purple[900],
                            )),
                        const WidgetSpan(
                            child: SizedBox(
                              width: 3,
                            )),
                        WidgetSpan(
                          child: Icon(
                            Icons.done_all,
                            size: 20,
                            color: data.userId == receiverid
                                ? Colors.purple
                                : Colors.purple[900],
                          ),
                        )
                      ])),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: formatDate(data.time!),
                      style: TextStyle(
                        fontSize: 12,
                        color: data.userId != receiverid
                            ? Colors.grey.shade100
                            : Colors.grey.shade400,
                      )),
                  const WidgetSpan(
                      child: SizedBox(
                        width: 3,
                      )),
                  // WidgetSpan(
                  //   child: Icon(
                  //     Icons.done_all,
                  //     size: 20,
                  //     color: data.isRead! ? Colors.green : Colors.grey,
                  //   ),
                  // )
                ])),
          ),
        ],
      ),
    );
  }

  Widget messages(Size size) {
    return Container(
      width: size.width,
      // alignment: data.userId != receiverid
      //     ? Alignment.centerLeft
      //     : Alignment.centerRight,
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.purple.withOpacity(0.2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                data.picture == "https://via.placeholder.com/50" ||
                    data.picture == null
                    ? Container(
                  height: size.height * 0.05,
                  width: size.width * 0.10,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ], shape: BoxShape.circle, color: Colors.grey),
                  child: Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: size.width * 0.07,
                      )),
                )
                    : Container(
                  height: size.height * 0.05,
                  width: size.width * 0.10,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(Base64Decoder().convert(
                              data.picture!.replaceAll(
                                  "data:image/png;base64,", "")))),
                      shape: BoxShape.circle,
                      color: Colors.grey),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size.height * 0.05,
                        width: size.width,
                        child: Row(
                          children: [
                            Text(
                              data.name!,
                              style: TextStyle(
                                  color: Color((math.Random().nextDouble() *
                                      0xFFFFFF)
                                      .toInt())
                                      .withOpacity(1.0)),
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Text(
                              formatDate(
                                data.time!,
                              ),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Text(
                        data.message!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      // RichText(
                      //     text: TextSpan(children: [
                      //   TextSpan(
                      //       text: formatDate(data.time!),
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         color: data.userId == receiverid
                      //             ? Colors.purple
                      //             : Colors.purple[900],
                      //       )),
                      //   const WidgetSpan(
                      //       child: SizedBox(
                      //     width: 3,
                      //   )),
                      //   WidgetSpan(
                      //     child: Icon(
                      //       Icons.done_all,
                      //       size: 20,
                      //       color: data.userId == receiverid
                      //           ? Colors.purple
                      //           : Colors.purple[900],
                      //     ),
                      //   )
                      // ])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 15,
          //   right: 15,
          //   child: RichText(
          //       text: TextSpan(children: [
          //     TextSpan(
          //         text: formatDate(data.time!),
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: data.userId != receiverid
          //               ? Colors.grey.shade100
          //               : Colors.grey.shade400,
          //         )),
          //     const WidgetSpan(
          //         child: SizedBox(
          //       width: 3,
          //     )),
          //     // WidgetSpan(
          //     //   child: Icon(
          //     //     Icons.done_all,
          //     //     size: 20,
          //     //     color: data.isRead! ? Colors.green : Colors.grey,
          //     //   ),
          //     // )
          //   ])),
          // ),
        ],
      ),
    );
  }
// Widget messages(Size size) {
//   return Container(
//     width: size.width,
//     // alignment: data.userId != receiverid
//     //     ? Alignment.centerLeft
//     //     : Alignment.centerRight,
//     alignment: Alignment.centerLeft,
//     child: Stack(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//           margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: data.userId != receiverid
//                   ? Colors.purple[900]
//                   : Colors.purple),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 data.message!,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white,
//                 ),
//               ),
//               RichText(
//                   text: TextSpan(children: [
//                 TextSpan(
//                     text: formatDate(data.time!),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: data.userId == receiverid
//                           ? Colors.purple
//                           : Colors.purple[900],
//                     )),
//                 const WidgetSpan(
//                     child: SizedBox(
//                   width: 3,
//                 )),
//                 WidgetSpan(
//                   child: Icon(
//                     Icons.done_all,
//                     size: 20,
//                     color: data.userId == receiverid
//                         ? Colors.purple
//                         : Colors.purple[900],
//                   ),
//                 )
//               ])),
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: 15,
//           right: 15,
//           child: RichText(
//               text: TextSpan(children: [
//             TextSpan(
//                 text: formatDate(data.time!),
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: data.userId != receiverid
//                       ? Colors.grey.shade100
//                       : Colors.grey.shade400,
//                 )),
//             const WidgetSpan(
//                 child: SizedBox(
//               width: 3,
//             )),
//             // WidgetSpan(
//             //   child: Icon(
//             //     Icons.done_all,
//             //     size: 20,
//             //     color: data.isRead! ? Colors.green : Colors.grey,
//             //   ),
//             // )
//           ])),
//         ),
//       ],
//     ),
//   );
// }
}
