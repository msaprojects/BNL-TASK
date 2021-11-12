import 'package:bnl_task/utils/warna.dart';
import 'package:bnl_task/views/pages/akun/akunpage.dart';
import 'package:bnl_task/views/pages/dashboard/dasboardpage.dart';
import 'package:bnl_task/views/pages/menu/menupage.dart';
import 'package:bnl_task/views/pages/progress/progresspage.dart';
import 'package:bnl_task/views/pages/tugas/tugaspage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // late SharedPreferences sp;
  // String? token = "", username = "", jabatan = "";
// * ceking token and getting dashboard value from Shared Preferences
  // cekToken() async {
  //   sp = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = sp.getString("access_token")!;
  //     username = sp.getString("username")!;
  //     jabatan = sp.getString("jabatan")!;
  //   });
  // }

  @override
  void initState() {
    // cekToken();
    super.initState();
  }

  // ! Initialize Variable
  // * please all variable drop here!
  // * and make sure variable have value don't let variable null
  int _currentTab = 0;
  PageStorageBucket bucket = PageStorageBucket();
  List<Widget> _currentPage = <Widget>[
    DashboardPage(),
    TugasPageSearch(),
    ProgressPageSearch(),
    AkunPage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _backPressed,
        child: Scaffold(
          body: PageStorage(bucket: bucket, child: _currentPage[_currentTab]),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedIconTheme: IconThemeData(color: Colors.red),
            selectedItemColor: primarycolor,
            unselectedItemColor: Colors.red.withOpacity(.40),
            onTap: (value) {
              setState(() {
                _currentTab = value;
              });
            },
            currentIndex: _currentTab,
            items: [
              BottomNavigationBarItem(
                  label: 'Home', icon: Icon(Icons.home_filled)),
              BottomNavigationBarItem(
                  label: 'Request', icon: Icon(Icons.document_scanner)),
              BottomNavigationBarItem(
                  label: 'Progress', icon: Icon(Icons.assessment_sharp)),
              BottomNavigationBarItem(
                  label: 'Account', icon: Icon(Icons.account_circle_outlined)),
            ],
          ),
        ));
  }

  // * handle exit apps when back button pressed 2 times
  Future<bool> _backPressed() async {
    DateTime currentTime = DateTime.now();
    bool backButton = DateTime == null ||
        currentTime.difference(DateTime.now()) > Duration(seconds: 2);
    if (backButton) {
      return false;
    } else {
      return true;
    }
  }
}
