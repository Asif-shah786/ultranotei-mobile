import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
    this.title = '',
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  String title;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
        imagePath: 'assets/icon/handshake.png',
        selectedImagePath: 'assets/icon/handshake.png',
        index: 0,
        isSelected: true,
        animationController: null,
        title: 'Dashboard'),
    TabIconData(
        imagePath: 'assets/icon/wallet.png',
        selectedImagePath: 'assets/icon/wallet.png',
        index: 1,
        isSelected: false,
        animationController: null,
        title: 'Wallet'),
    TabIconData(
        imagePath: 'assets/icon/icons8-bank-50.png',
        selectedImagePath: 'assets/icon/icons8-bank-50.png',
        index: 4,
        isSelected: false,
        animationController: null,
        title: 'Deposit'),
    TabIconData(
        imagePath: 'assets/icon/message_icon.png',
        selectedImagePath: 'assets/icon/message_icon.png',
        index: 2,
        isSelected: false,
        animationController: null,
        title: 'Chat'),
    TabIconData(
        imagePath: 'assets/icon/envelop.png',
        selectedImagePath: 'assets/icon/envelop.png',
        index: 3,
        isSelected: false,
        animationController: null,
        title: 'Message'),
    TabIconData(
        imagePath: 'assets/icon/user.png',
        selectedImagePath: 'assets/icon/user.png',
        index: 5,
        isSelected: false,
        animationController: null,
        title: 'Profile'),
  ];
}
