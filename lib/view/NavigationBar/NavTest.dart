import 'package:flutter/material.dart';
import 'package:mfp_app/allWidget/allWidget.dart';
import 'package:mfp_app/view/Doing/doingSC.dart';
import 'package:mfp_app/view/Menu/Menu.dart';
import 'package:mfp_app/view/Shop/Shop.dart';
import 'package:mfp_app/view/Today/TodaySc.dart';

class NavTest extends StatefulWidget {
  NavTest({Key key}) : super(key: key);

  @override
  _NavTestState createState() => _NavTestState();
}

class _NavTestState extends State<NavTest> {
  bool auth = false;
  int pageIndex = 0;
   PageController pageController;

  

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: this.pageIndex);
  }


  buildAuthScreen() {
    return Scaffold(
       appBar: AppBar(),
    
      body: PageView(
        controller: pageController,
        children: [
         TodaySc(),
        DoingSC(),
        ShopSC(),
        MenuSC(),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: this.pageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            this.pageIndex = index;
          });
          pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Timeline'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  buildAuthScreen(),
    );
  }
}

class ScrollAppBar {
}
