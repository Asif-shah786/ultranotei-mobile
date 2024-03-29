import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/utils/utils.dart';
import 'package:ultranote_infinity/widget/login_btn.dart';
import 'package:ultranote_infinity/widget/signup_btn.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../app_theme.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  String name = "E X";
  String bytes = '';

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
    getUser();
  }

  getUser() {
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((value) {
      setState(() {
        bytes = value.image.toString();
        name = '${value.firstName} ${value.lastName}';
      });
    });
  }

  void addAllListData() {
    const int count = 9;

    /*  listViews.add(
      TitleView(
        titleTxt: 'Mediterranean diet',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      MediterranesnDietView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Meals today',
        subTxt: 'Customize',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      MealsListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Body measurement',
        subTxt: 'Today',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      BodyMeasurementView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Water',
        subTxt: 'Aqua SmartBottle',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      WaterView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 7, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController!,
      ),
    );
    listViews.add(
      GlassView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController!,
                  curve: Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!),
    );*/
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  var height, width;

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
          title: Text('My Profile', style: CustomAppTheme.actionBarText),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Container(
            height: height,
            width: width,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    bytes == "https://via.placeholder.com/50" ||
                            bytes == null ||
                            bytes == ""
                        ? Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ], shape: BoxShape.circle, color: Colors.grey),
                            child: Center(
                              child: Text(
                                '${name.split(' ')[0].characters.isNotEmpty ? name.split(' ')[0].characters.first : ''}${name.split(' ')[1].characters.isNotEmpty ? name.split(' ')[1].characters.first : ''}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                            ))
                        : Container(
                            width: 75, // Set the width as needed
                            height: 75, // Set the height as needed
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(Base64Decoder().convert(
                                        bytes.replaceAll(
                                            "data:image/png;base64,", "")))),
                                shape: BoxShape.circle,
                                color: Colors.grey),
                          )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "${name}",
                    style: CustomAppTheme.actionBarText,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                LoginBtn("Edit Profile", () {
                  editProfile();
                }, CustomAppTheme.btnWhiteText),
                SizedBox(
                  height: 20,
                ),
                LoginBtn("Address Book", () {
                  contacts();
                }, CustomAppTheme.btnWhiteText),
                SizedBox(
                  height: 20,
                ),
                LoginBtn("Reset Password", () {
                  resetPass();
                }, CustomAppTheme.btnWhiteText),
                SizedBox(
                  height: 20,
                ),
                LoginBtn("Activity Log", () {
                  activityLog();
                }, CustomAppTheme.btnWhiteText),
                SizedBox(
                  height: 20,
                ),
                LoginBtn("Settings", () {
                  setting();
                }, CustomAppTheme.btnWhiteText),
                SizedBox(
                  height: 20,
                ),
                SignupBtn("Log out", () {
                  signout();
                }, CustomAppTheme.btnBlackText),
                SizedBox(
                  height: height * 0.2,
                ),
              ],
            ),
          ),
        ));
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  editProfile() {
    print('edit profile');
    Navigator.pushNamed(context, '/editprofilescreen');
  }

  contacts() {
    print('contact Screen');
    Navigator.pushNamed(context, '/contactscreen');
  }

  resetPass() {
    print('resetPass');
    Navigator.pushNamed(context, '/resetpassscreen');
  }

  activityLog() {
    print('activity log');
    Navigator.pushNamed(context, '/activitylogscreen');
  }

  setting() {
    print('setting');
    Navigator.pushNamed(context, '/setingscreen');
  }

  signout() {
    print('log out');

    UserLocalStore userLocalStore = new UserLocalStore();
    userLocalStore.clearUserData();
    showSnackBar(context, "Log out successfully");
    Navigator.pushReplacementNamed(context, '/loginsignupscreen');
  }
}
