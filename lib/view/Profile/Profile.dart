import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mfp_app/Api/Api.dart';
import 'package:mfp_app/allWidget/allWidget.dart';
import 'package:mfp_app/constants/colors.dart';
import 'package:mfp_app/utils/app_theme.dart';

class ProfileSc extends StatefulWidget {
  final String userid;
    final String userimageUrl;

  ProfileSc({Key key, this.userid, this.userimageUrl}) : super(key: key);

  @override
  _ProfileScState createState() => _ProfileScState();
}

class _ProfileScState extends State<ProfileSc>  {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();
      
  var checktoken;

  var datagetuserprofile;

  var displayName1="";

  var gender;

  var firstName;

  var lastName;

  var id;

  var email="";

  var image;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api.getuserprofile("${widget.userid}").then((responseData) => ({
            if (responseData.statusCode == 200)
              {
                datagetuserprofile = jsonDecode(responseData.body),
                setState(() {
                  displayName1 = datagetuserprofile["data"]["displayName"];
                  gender = datagetuserprofile["data"]["gender"];
                  firstName = datagetuserprofile["data"]["firstName"];
                  lastName = datagetuserprofile["data"]["lastName"];
                  id = datagetuserprofile["data"]["id"];
                  email = datagetuserprofile["data"]["email"];
                  image = datagetuserprofile["data"]["imageURL"];
                }),
                print('displayName1$displayName1'),
                print('gender$gender'),
                print('firstName$firstName'),
                print('lastName$lastName'),
                print('id$id'),
                print('email$email'),
                print('${datagetuserprofile["data"]["username"]}'),
              }
          }));
  }
  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return displayName1==""? Container(
            color: Colors.white,
            child: Center(child: CupertinoActivityIndicator())): Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            controller: _trackingScrollController,
            slivers: [
              primaryAppBar(context, "",widget.userid,image),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 130.0,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 2.0, left: 25.0),
                            child: CircleAvatar(
                              radius: 42.0,
                              backgroundImage:image==""? NetworkImage(
                                  'https://via.placeholder.com/150'): NetworkImage(
                                 'https://today-api.moveforwardparty.org/api$image/image') ,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 38.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  displayName1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: AppTheme.BodyTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                      fontWeight: FontWeight.bold),
                                ),
                               
                                Text(
                                  email,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15.5,
                                    fontFamily: AppTheme.FontAnakotmaiLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width/5,),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 28.0,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                  child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(top: 18.0, left: 25.0),
                  child: Text(
                    'เพจที่ดูแล',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppTheme.BodyTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    height: 150,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.0, left: 30.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 36.0,
                                      backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/150'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Nuttawut',
                                        style: TextStyle(
                                          color: Colors.black54,
                                         fontSize: AppTheme.SmallTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiLight,
                                     
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 34.0,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 36.0,
                                      backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/150'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'สร้างเพจ',
                                        style: TextStyle(
                                          color: Colors.black54,
                                        fontSize: AppTheme.SmallTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 60.0,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 2.0, left: 25.0),
                            child: Text(
                              'สมาชิกพรรค',
                              style: TextStyle(
                                  color: Colors.black,
                                 fontSize: AppTheme.BodyTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                      fontWeight: FontWeight.bold,),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 18.0,
                              left: 65.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'ยังไม่ได้เป็นสมาชิก',
                                  style: TextStyle(
                                      color: primaryColor,
                                   fontSize: AppTheme.BodyTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                      fontWeight: FontWeight.bold,),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4, left: 16.0),
                            child: Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 60.0,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 2.0, left: 25.0),
                            child: Text(
                              'ประวัติการบริจาค',
                              style: TextStyle(
                                  color: Colors.black,
                                 fontSize: AppTheme.BodyTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                      fontWeight: FontWeight.bold,),
                            ),
                          ),
                          SizedBox(
                            width: 182.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4, left: 16.0),
                            child: Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 60.0,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 2.0, left: 25.0),
                            child: Text(
                              'ติดตาม',
                              style: TextStyle(
                                  color: Colors.black,
                                 fontSize: AppTheme.BodyTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                      fontWeight: FontWeight.bold,),
                            ),
                          ),
                          SizedBox(
                            width: 252.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4, left: 16.0),
                            child: Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 60.0,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 2.0, left: 25.0),
                            child: Text(
                              'ประวัติ',
                              style: TextStyle(
                                  color: Colors.black,
                                 fontSize: AppTheme.BodyTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                      fontWeight: FontWeight.bold,),
                            ),
                          ),
                          SizedBox(
                            width: 255.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4, left: 16.0),
                            child: Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 60.0,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 2.0, left: 25.0),
                            child: Text(
                              'เชื่อมต่อ social media',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: AppTheme.BodyTextSize,
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                      fontWeight: FontWeight.bold,),
                            ),
                          ),
                          SizedBox(
                            width: 126.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4, left: 16.0),
                            child: Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                  child: Container(
                color: Colors.white,
                height: 26.0,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
