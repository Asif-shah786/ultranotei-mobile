import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';
import 'package:ultranote_infinity/service/api_service.dart';
import 'package:ultranote_infinity/utils/UserLocalStore.dart';
import 'package:ultranote_infinity/widget/activity_log_card.dart';

import '../app_theme.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({Key? key}) : super(key: key);

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {

  bool _isInAsyncCall = false;
  List list=[];


  getActivity(){
    UserLocalStore userLocalStore = new UserLocalStore();
    Future<CurrentUser> cUSer = userLocalStore.getLoggedInUser();
    cUSer.then((cvalue) {

      setState(() {
        _isInAsyncCall=true;
      });
      ApiService.instance.getActivity( cvalue.id).then((value) {


        setState(() {
          list=value;
          _isInAsyncCall=false;
        });


      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    getActivity();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/back/loginpage_back.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: CustomAppTheme.black_bar,
            elevation: 0,
            centerTitle: true,
            title: Text('Activity Log', style: CustomAppTheme.actionBarText),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) => Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: ActivityLog(list[i]['action'],list[i]['ip'],list[i]['date']),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
