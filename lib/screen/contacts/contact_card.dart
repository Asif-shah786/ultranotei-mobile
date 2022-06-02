import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/contacts/contact_controller.dart';
import 'package:ultranote_infinity/screen/contacts/contact_list_model.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';

class ContactCard extends StatefulWidget {
  ContactListMOdel? model;
  int? index;
  ContactCard({this.model, this.index});
  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 5,
      color: CustomAppTheme.transparentpurple,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        child: Container(
          height: height * 0.15,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Label : ${widget.model!.label}',
                style: CustomAppTheme.smallPinkBoldText,
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: Container(
                  height: height,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address : ',
                        maxLines: 2,
                        style: CustomAppTheme.smallWhiteBoldText,
                      ),
                      Expanded(
                        child: Container(
                          height: height,
                          width: width,
                          child: Text(
                            '${widget.model!.address}',
                            maxLines: 2,
                            style: CustomAppTheme.smallGreyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: height * 0.05,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(4),
                      onPressed: () {
                        Clipboard.setData(
                                ClipboardData(text: "${widget.model!.address}"))
                            .then((value) {
                          showSnackBar(context, "Copied");
                        });
                      },
                      icon: Icon(Icons.paste),
                      color: Colors.white,
                    ),
                    IconButton(
                      padding: EdgeInsets.all(4),
                      onPressed: () {
                        deleteContatApi(widget.index!);
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteContatApi(int index) {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      ApiService.instance.deleteAddress(cvalue.id, index).then((value) {
        var extractData = json.decode(value.body);

        if (value.statusCode == 200) {
          print('Add Data Response $extractData');
          print(extractData['message']);

          List addressList = extractData['userData']['contacts'];
          ContactController.to.clearList();
          for (int i = 0; i < addressList.length; i++) {
            var label = addressList[i][0];
            var addresee = addressList[i][1];

            ContactListMOdel model =
                ContactListMOdel(address: addresee, label: label);
            ContactListMOdel.contactList.add(model);
          }

          ContactController.to.getContactList(ContactListMOdel.contactList);
          showSnackBar(context, extractData['message']);
        } else {
          showSnackBar(context, extractData['message']);
        }
      });
    });
  }
}
