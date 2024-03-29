import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:ultranote_infinity/bottom_navigation_view/bottom_bar_view.dart';
import 'package:ultranote_infinity/screen/chat/user_chat_screen.dart';
import 'package:ultranote_infinity/screen/chat/user_home_controller.dart';
import 'package:ultranote_infinity/screen/contacts/contact_controller.dart';
import 'package:ultranote_infinity/service/socket_service.dart';
import 'package:ultranote_infinity/tab/deposit_tab.dart';
import 'package:ultranote_infinity/tab/message_tab.dart';
import 'package:ultranote_infinity/tab/wallet_tab.dart';
import 'package:ultranote_infinity/tab/profile_tab.dart';
import 'package:ultranote_infinity/tab/dashboard_tab.dart';

import '../app_theme.dart';
import '../tab_icon_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container();

  @override
  void initState() {
    Get.put(UserChatController());
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    SocketService.connect();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = DashboardTab(
        animationController: animationController,
        goToProfile: (() => {
              setState(() {
                tabBody = ProfileTab(animationController: animationController);
              })
            }));
    super.initState();
    SocketService.OnConnect((p0) => {print("hello socket " + p0)});
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/back/loginpage_back.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: Container(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: FutureBuilder<bool>(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return Stack(
                      children: <Widget>[
                        tabBody,
                        bottomBar(),
                      ],
                    );
                  }
                },
              ),
            ),
          )),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            print('center click');
            /* Navigator.push(context,
                MaterialPageRoute(builder: (context) => Post1()));*/
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = DashboardTab(
                      animationController: animationController,
                      goToProfile: (() => {
                            setState(() {
                              tabBody = ProfileTab(
                                  animationController: animationController);
                            })
                          }));
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = WalletTab(animationController: animationController);
                });
              });
            } else if (index == 4) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      UserChatScreen(animationController: animationController);
                });
              });
            } else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MessageTab(animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      DepositTab(animationController: animationController);
                });
              });
            } else if (index == 5) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      ProfileTab(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
