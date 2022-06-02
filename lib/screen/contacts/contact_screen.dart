import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultranote_infinity/app_theme.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/screen/contacts/contact_card.dart';
import 'package:ultranote_infinity/screen/contacts/contact_controller.dart';
import 'package:ultranote_infinity/screen/contacts/contact_list_model.dart';
import 'package:ultranote_infinity/screen/scan_qr_code_screen.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/dialog_text_field.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  var height, width;
  TextEditingController labelController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: CustomAppTheme.black_bar,
          elevation: 0,
          centerTitle: true,
          title: Text('Address Book', style: CustomAppTheme.actionBarText),
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
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<ContactController>(builder: (contactObj) {
                  return Container(
                    height: height,
                    width: width,
                    child: contactObj.allContactList.isEmpty
                        ? Center(
                            child: Text('No Contact Available in Address Book',
                                style: CustomAppTheme.actionBarText),
                          )
                        : ListView.builder(
                            itemCount: contactObj.allContactList.length,
                            itemBuilder: (context, index) {
                              return ContactCard(
                                  index: index,
                                  model: contactObj.allContactList[index]);
                            },
                          ),
                  );
                }),
              ),
              Container(
                  height: height * 0.1,
                  width: width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: CustomAppTheme.cardpurple,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: height,
                        width: width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Total Contacts",
                              style: CustomAppTheme.btnWhiteText,
                            ),
                            GetBuilder<ContactController>(builder: (cObj) {
                              return Container(
                                height: height * 0.06,
                                width: width * 0.12,
                                child: Center(
                                    child: Text(
                                  '${cObj.allContactList.length}',
                                  style: CustomAppTheme.smallBlueBoldText,
                                )),
                              );
                            })
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          addAddress(context);
                        },
                        child: Card(
                          elevation: 9,
                          color: CustomAppTheme.black_login,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          child: Container(
                            height: height * 0.06,
                            width: width * 0.3,
                            child: Center(
                                child: Text(
                              'Add Address',
                              style: CustomAppTheme.btnWhiteText,
                            )),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }

  addAddress(BuildContext context) {
    print('add address');
    customDialog(context);
  }

  customDialog(BuildContext context) {
    var walletDialog = Align(
      alignment: Alignment(0, -1),
      child: Material(
        color: Color(0xffffff),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          margin: EdgeInsets.only(top: 100),
          height: height * 0.45,
          width: 350,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Text(
                  'Add Address',
                  style: CustomAppTheme.btnBlackText,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DialogTextField(
                    "Give Label", labelController, TextInputType.name, false),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: height * 0.1,
                width: width,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: DialogTextField("Write Wallet address",
                              addressController, TextInputType.name, false),
                        ),
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.all(4),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Future.delayed(const Duration(milliseconds: 200), () {
                            Navigator.of(context)
                                .push(
                                  new MaterialPageRoute(
                                      builder: (_) => new ScanQRCodeScreen()),
                                )
                                .then((val) => val ? setAddress() : null);
                          });
                        },
                        icon: Icon(Icons.qr_code),
                        color: CustomAppTheme.black_login),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LoginBtn('Add Address', () {
                  String labelName = labelController.text.toString().trim();
                  String address = addressController.text.toString().trim();

                  if (labelName.isEmpty) {
                    showSnackBar(context, "Enter  labelName");
                    return;
                  }
                  if (address.isEmpty) {
                    showSnackBar(context, "Enter  address");
                    return;
                  }
                  AddContactAPI(labelName, address);
                  Navigator.pop(context);
                }, CustomAppTheme.btnWhiteText),
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

  AddContactAPI(String label, String address) {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {
      // setState(() {
      //   _isInAsyncCall = true;
      // });
      ApiService.instance.addAddress(cvalue.id, label, address).then((value) {
        var extractData = json.decode(value.body);

        if (value.statusCode == 200) {
          print('Add Data Response $extractData');
          print(extractData['message']);
          List addressList = extractData['userData']['contacts'];
          print('-----------------------------');
          print(addressList.length);
          ContactController.to.clearList();
          print('-----------------------------');
          print(addressList.length);
          for (int i = 0; i < addressList.length; i++) {
            var label = addressList[i][0];
            var addresee = addressList[i][1];

            ContactListMOdel model =
                ContactListMOdel(address: addresee, label: label);
            ContactListMOdel.contactList.add(model);
          }

          ContactController.to.getContactList(ContactListMOdel.contactList);
        } else {
          showSnackBar(context, extractData['message']);
        }
      });
    });
  }

  setAddress() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String address = sp.getString('address')!;
    print(address);
    setState(() {
      addressController.text = address;
    });
  }
}
