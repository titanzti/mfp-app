import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mfp_app/Api/Api.dart';
import 'package:mfp_app/allWidget/allWidget.dart';
import 'package:mfp_app/constants/colors.dart';
import 'package:mfp_app/model/pagemodel.dart';
import 'package:mfp_app/utils/internetConnectivity.dart';
import 'package:mfp_app/utils/router.dart';
import 'package:mfp_app/view/NavigationBar/nav_screen.dart';
import 'package:mfp_app/view/Profile/profile.dart';
import 'package:mfp_app/view/Search/search.dart';

class DoingSC extends StatefulWidget {
  // DoingSC({Key? key}) : super(key: key);

  @override
  _DoingSCState createState() => _DoingSCState();
}

class _DoingSCState extends State<DoingSC> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  var token;

  var userid;

  var userimageUrl;

  var datagetuserprofile;

  var image;

  bool pageObjloading;

  var jsonResponse;
  List<PageObjective> pageobjslist = [];
  StreamController _pageobjController;
  Future getpageObj;
  DateTime backward;
  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
      DateTime currentDate = DateTime.now();



    

     Api.gettoke().then((value) => value({
        setState(() {
             token = value;
        }),
         
            print('token$token'),
          }));
      //--
 Api.getmyuid().then((value) => ({
            setState(() {
              userid = value;
            }),
            print('userid$userid'),
          }));
    Future.delayed(Duration.zero, () async {
      print('delayedgetpost');
    
      //--
  await  Api.getuserprofile("$userid").then((responseData) async => ({
            if (responseData.statusCode == 200)
              {
                datagetuserprofile = jsonDecode(responseData.body),
                setState(() {
                  image = datagetuserprofile["data"]["imageURL"];
                }),
                print('image$image'),
              }
          }));
      //--\
    await  Api.getimageURL().then((value) => ({
            setState(() {
              userimageUrl = value;
            }),
            print('userimageUrl$userimageUrl'),
          }));
      //--
     
    });
     Api.getdoing(Jiffy(currentDate).subtract(months: 1)).then((responseData) async => ({
     print('getdoing'),
            setState(() {
              pageObjloading = true;
            }),
            if (responseData.statusCode == 200)
              {
                jsonResponse = jsonDecode(responseData.body),
                print('jsonResponse$jsonResponse'),
                for (Map i in jsonResponse["data"])
                  {
                    setState(() {
                      // pagename =i['page'][0]['name'];
                    }),

                    pageobjslist.add(PageObjective.fromJson(i)),
                    _pageobjController.add(responseData),

                    // var stroycoverImage= i["coverImage"];
                  },
                // print("Response  :$storytestreplaceAll"),
                // print('titalpost$titalpost'),
                setState(() {
                  pageObjloading = false;
                }),
              }
            else if (responseData.statusCode == 400)
              {}
          }));
    _pageobjController = new StreamController();
     print('initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            controller: _trackingScrollController,
            slivers: [
              primaryAppBar(
                  context,
                  token,
                  userid,
                  image,
                  Search(),
                  ProfileSc(
                    userid: userid,
                    token: token,
                  )),
              SliverToBoxAdapter(
                child: Container(
                  color: primaryColor,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'สิ่งที่ "พรรคก้าวไกล" กำลังทำอยู่',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Anakotmai',
                          fontSize: 19),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'สิ่งที่กำลังทำใน 1 เดือนที่ผ่านมา',
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: MColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Anakotmai',
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 1,
                //   mainAxisSpacing: 5,
                //  // horizontal spacing between the items
                //   crossAxisSpacing: 5,
                   crossAxisCount: 1,
       mainAxisSpacing: 10,
       crossAxisSpacing: 10,
       childAspectRatio: 1
                  
                  // mainAxisSpacing: 5.0,
                  // crossAxisSpacing: 5.0,
                  // childAspectRatio: 3.0,
                  
                ),
                
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return StreamBuilder(
                      stream: _pageobjController.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(5),

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:2),
                          itemBuilder: (BuildContext context, int index) {
                            var e = pageobjslist[index];

                            return Container(
                              
                              height: MediaQuery.of(context).size.height/10,
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(8),
                              //     color: Colors.grey[100],
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.grey.withOpacity(1),
                              //         blurRadius: 0.5,
                              //         spreadRadius: 0.5,
                              //       ),
                              //     ]),
                              child: Column(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 55.0,
                                    backgroundImage:
                                        NetworkImage('https://today-api.moveforwardparty.org/api${e.iconUrl}/image'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 10),
                                    child: Center(
                                      child: Text(
                                        e.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Anakotmai-Bold',
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  childCount: 1,
                ),
              ),
         
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.grey[200],
                height: 10,
                thickness: 9,
              )),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'สิ่งที่ทำที่เคยทำมา',
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: MColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Anakotmai',
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(16),
                        width: width,
                        height: hight / 7.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[50],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 0.5,
                                spreadRadius: 0.5,
                              ),
                            ]),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 16.0, left: 14.0),
                              child: CircleAvatar(
                                radius: 36.0,
                                backgroundImage:
                                    AssetImage('images/morkimage6.png'),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 18.0, left: 110),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '#พรบจัดสรร',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Anakotmai-Bold',
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '#ร่างพระราชบัญญัการจัดสรรที่ดิน\n(ฉบับที่..) พ.ศ. ....',
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: 'Anakotmai',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 10,
                thickness: 6.0,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
