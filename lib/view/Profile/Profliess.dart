import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:mfp_app/Api/Api.dart';
import 'package:mfp_app/allWidget/CarouselsLoading.dart';
import 'package:mfp_app/allWidget/PostButton.dart';
import 'package:mfp_app/allWidget/allWidget.dart';
import 'package:mfp_app/allWidget/fontsize.dart';
import 'package:mfp_app/constants/colors.dart';
import 'package:mfp_app/model/postlistSSmodel.dart';
import 'package:mfp_app/utils/router.dart';
import 'package:mfp_app/view/Auth/login-register.dart';
import 'package:http/http.dart' as Http;

class Profliess extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String phonenumber;
  final String lineId;
  final String facebookUrl;
  final String twitterUrl;
  final bool isOfficial;
  final String pageUsername;
  final bool isFollow;
  const Profliess({
    Key key,
    this.id,
    this.image,
    this.name,
    this.phonenumber,
    this.lineId,
    this.facebookUrl,
    this.twitterUrl,
    this.isOfficial,
    this.pageUsername,
    this.isFollow,
  }) : super(key: key);

  // ShopSC({Key? key}) : super(key: key);

  @override
  _ProfliessState createState() => _ProfliessState();
}

class _ProfliessState extends State<Profliess> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  var token;

  var userid;
  StreamController _postsController;
  bool isFollow=false;
  var userimageUrl;
  List<PostListSS> listpostss = [];
  Future getPostss;
  var dataht;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  int _currentMax = 5;
  var  myuid;
  bool islike = false;

  bool isLoading = false;
  var story;
  TextEditingController _detailController = TextEditingController();
  bool _isLoadMoreRunning = false;

  int page = 5;
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('initState');
    super.initState();
    setState(() {
      _scrollController.addListener(_loadMore);

      Api.gettoke().then((value) => value({
            token = value,
            print('token$token'),
          }));

      Api.getmyuid().then((value) => ({
            setState(() {
              userid = value;
            }),
            print('userid$userid'),
          }));
      Api.getimageURL().then((value) => ({
            setState(() {
              userimageUrl = value;
            }),
            print('userimageUrl$userimageUrl'),
          }));
      Api.getpagess(userid, token, widget.id).then((responseData) => ({
            print('getpagess${responseData.body}'),
            if (responseData.statusCode == 200)
              {
                dataht = jsonDecode(responseData.body),
              }
          }));
      _getPostListSS(widget.id, _currentMax);
    });
    _postsController = new StreamController();
  }

  Future _getPostListSS(String idss, int offset) async {
    final responseData = await Http.get(
        "https://today-api.moveforwardparty.org/api/page/$idss/post/?offset=$offset&limit=15");

    print('getPostListSS');
    if (responseData.statusCode == 200) {
      dataht = jsonDecode(responseData.body);
      print(dataht);
      for (var i in dataht["data"]) {
        // i["story"] = '',

        listpostss.add(PostListSS.fromJson(i));
        // story = dataht["data"]["story"]["story"],
        // print('story$story'),
        _postsController.add(dataht);
        print(listpostss.length);
      }

      // loading = false,
    }
  }

  void _loadMore() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('AT end');
      await new Future.delayed(const Duration(milliseconds: 100));

      setState(() {
        _currentMax = _currentMax + 5;
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom

        try {
          _getPostListSS(widget.id, _currentMax);
        } catch (err) {
          print('Something went wrong!');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              primaryAppBar(context, token, userid, userimageUrl),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.grey[100],
                height: 3,
                thickness: 3.0,
              )),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: MColors.primaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(
                                  "https://today-api.moveforwardparty.org/api${widget.image}/image"),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontFamily: 'Anakotmai',
                                      fontWeight: FontWeight.bold),
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
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image.asset(
                          "images/Group 11904.png",
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: -80.0,
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundImage: NetworkImage(
                                "https://today-api.moveforwardparty.org/api${widget.image}/image"),
                            backgroundColor: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                color: Colors.white,
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 22,
                            fontFamily: 'Anakotmai-Bold',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 65.0),
                      child: Center(
                        child: Text(
                          '@${widget.pageUsername}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontFamily: 'Anakotmai',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              SliverToBoxAdapter(
                  child: Divider(
                color: Colors.transparent,
                height: 3,
                thickness: 6.0,
              )),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                         isFollow == true
                              ? InkWell(
                                onTap: ()async{
 HapticFeedback.lightImpact();
                                      var jsonResponse;
                                      token == null || token == ""
                                          ? Navigate.pushPage(
                                              context, Loginregister())
                                          : await Api.isfollowpage(
                                                  widget.id, userid, token)
                                              .then((value) => ({
                                                    jsonResponse =
                                                        jsonDecode(value.body),
                                                    print(
                                                        'message${jsonResponse['message']}'),
                                                    if (value.statusCode == 200)
                                                      {
                                                        if (jsonResponse[
                                                                'message'] ==
                                                            "Followed Page Success")
                                                          {
                                                            setState(() {
                                                           isFollow=true;
                                                              islike =
                                                                  jsonResponse[
                                                                          'data']
                                                                      [
                                                                      'isLike'];
                                                            
                                                            }),
                                                          }
                                                        else if (jsonResponse[
                                                                'message'] ==
                                                            "Unfollow Page Success")
                                                          {
                                                            setState(() {
                                                              islike =
                                                                  jsonResponse[
                                                                          'data']
                                                                      [
                                                                      'isLike'];
                                                              isFollow=false;

                                                            }),
                                                          }
                                                      }
                                                  }));
                                      print("กดlike");
                                    },
                                child: Container(
                                    width: 110.0,
                                    height: 40.0,
                                    margin: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text(
                                        'กำลังติดตาม',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontFamily: 'Anakotmai',
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        border: Border.all(color: primaryColor),
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(20))),
                                  ),
                              )
                              : InkWell(
                                onTap: ()async{
                                   HapticFeedback.lightImpact();
                                      var jsonResponse;
                                      token == null || token == ""
                                          ? Navigate.pushPage(
                                              context, Loginregister())
                                          : await Api.isfollowpage(
                                                  widget.id, userid, token)
                                              .then((value) => ({
                                                    jsonResponse =
                                                        jsonDecode(value.body),
                                                    print(
                                                        'message${jsonResponse['message']}'),
                                                    if (value.statusCode == 200)
                                                      {
                                                        if (jsonResponse[
                                                                'message'] ==
                                                            "Followed Page Success")
                                                          {
                                                            setState(() {
                                                           isFollow=true;
                                                              islike =
                                                                  jsonResponse[
                                                                          'data']
                                                                      [
                                                                      'isLike'];
                                                            
                                                            }),
                                                          }
                                                        else if (jsonResponse[
                                                                'message'] ==
                                                            "Unfollow Page Success")
                                                          {
                                                            setState(() {
                                                              islike =
                                                                  jsonResponse[
                                                                          'data']
                                                                      [
                                                                      'isLike'];
                                                              isFollow=false;

                                                            }),
                                                          }
                                                      }
                                                  }));
                                      print("กดlike");

                                },
                                child: Container(
                                    width: 110.0,
                                    height: 40.0,
                                    margin: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text(
                                        'ติดตาม',
                                        style: TextStyle(
                                          color: MColors.textDark,
                                          fontSize: 14.0,
                                          fontFamily: 'Anakotmai',
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: MColors.primaryWhite,
                                        border: Border.all(color: primaryColor),
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(20))),
                                  ),
                              ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Icon(Icons.person),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 6.0),
                                child: Text(
                                  '4 พัน',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16.0,
                                      fontFamily: 'Anakotmai',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.0),
                            child: Text(
                              'เกี่ยวกับ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontFamily: 'Anakotmai-Bold',
                                fontWeight: FontWeight.bold,
                              ),
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
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 170,
                                height: 145,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[100],
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(1),
                                        blurRadius: 0.5,
                                        spreadRadius: 0.5,
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage: NetworkImage(
                                            'https://via.placeholder.com/150'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          '#น้ำท่วม',
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Anakotmai-Bold',
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Container(
                                width: 170,
                                height: 145,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[100],
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(1),
                                        blurRadius: 0.5,
                                        spreadRadius: 0.5,
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage: NetworkImage(
                                            'https://via.placeholder.com/150'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          '# WALKTODAY',
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Anakotmai-Bold',
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
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
                child: StreamBuilder(
                  stream: _postsController.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CarouselLoading());
                    }
                    // if (snapshot.connectionState == ConnectionState.none) {
                    //   return Center(child: Text(messger));
                    // }
                    return Builder(
                      builder: (BuildContext context) {
                        return Scrollbar(
                          isAlwaysShown: true,
                          child: ListView.builder(
                              // controller: _scrollController,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // padding: const EdgeInsets.all(8.0),
                              scrollDirection: Axis.vertical,
                              itemCount: listpostss.length,
                              itemBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                // if (listModelPostClass.length == 0) {
                                //   return Center(
                                //       child: CupertinoActivityIndicator());
                                // }
                                final nDataList1 = listpostss[index];

                                //   if(fistload==true){
                                // if (index == listModelPostClass.length - 3) {

                                // return  BuildRecommendedUserPage();
                                //  }
                                // }else{
                                //   return SizedBox.shrink();
                                // }

                                if (index == listpostss.length) {
                                  print('เท่ากัน');
                                }

                                //  else {
                                //   PostList(
                                //     nDataList1.post.title,
                                //     nDataList1.post.detail,
                                //     nDataList1.page.name,
                                //     nDataList1.page.createdDate,
                                //     nDataList1.post.gallery,
                                //     nDataList1.post.likeCount,
                                //     nDataList1.post.commentCount,
                                //     nDataList1.post.shareCount,
                                //   );
                                // }

                                return PostList(
                                  nDataList1.title,
                                  nDataList1.detail,
                                  widget.name,
                                  nDataList1.createdDate,
                                  nDataList1.gallery,
                                  nDataList1.likeCount,
                                  nDataList1.commentCount,
                                  nDataList1.shareCount,
                                    nDataList1.coverImage,
                                );
                              }),
                        );
                      },
                    );
                  },
                ),
              ),
              if (_isLoadMoreRunning == true)
                  SliverToBoxAdapter(
                    child: Center(
                        child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              MColors.primaryColor)),
                    )),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostList(
      String posttitle,
      String subtitle,
      String authorposttext,
      DateTime dateTime,
      List<Gallery> gallery,
      int likeCount,
      int commentCount,
      int shareCount,
      String coverimage,
      ) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        color: MColors.containerWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           coverimage != ""
                ? CachedNetworkImage(
                    imageUrl:"https://today-api.moveforwardparty.org/api$coverimage/image",
                    placeholder: (context, url) =>
                        new CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: new Image.network(
                        "https://today-api.moveforwardparty.org/api$coverimage/image",
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            // gallery.length != 0 ? myAlbumCard(gallery) : SizedBox.shrink(),
            // Image.network(gallery[0].signUrl),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: texttitlepost(posttitle, context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: subtexttitlepost(subtitle, context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      fixtextauthor(),
                      // authorpost(authorposttext, context, dateTime),
                      texttimetimestamp(dateTime),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            islike == false
                                ? PostButton(
                                    icon: Icon(
                                      Icons.favorite_outline,
                                      color: MColors.primaryBlue,
                                      size: 20.0,
                                    ),
                                    label: '$likeCount ถูกใจ',
                                    onTap: () async {
                                      HapticFeedback.lightImpact();

                                      var jsonResponse;
                                      token == "" || token == null
                                          ? Navigate.pushPage(
                                              context, Loginregister())
                                          : await Api.islike(
                                                  widget.id, userid, token)
                                              .then((value) => ({
                                                    jsonResponse =
                                                        jsonDecode(value.body),
                                                    print(
                                                        'message${jsonResponse['message']}'),
                                                    if (value.statusCode == 200)
                                                      {
                                                        if (jsonResponse[
                                                                'message'] ==
                                                            "Like Post Success")
                                                          {
                                                            setState(() {
                                                              islike =
                                                                  jsonResponse[
                                                                          'data']
                                                                      [
                                                                      'isLike'];

                                                              likeCount++;
                                                            }),
                                                          }
                                                        else if (jsonResponse[
                                                                'message'] ==
                                                            "UnLike Post Success")
                                                          {
                                                            setState(() {
                                                              islike =
                                                                  jsonResponse[
                                                                          'data']
                                                                      [
                                                                      'isLike'];

                                                              likeCount--;
                                                            }),
                                                          }
                                                      }
                                                  }));
                                      print("กดlike");
                                    },
                                  )
                                : PostButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: MColors.primaryBlue,
                                      size: 20.0,
                                    ),
                                    label: '$likeCount ถูกใจ',
                                    onTap: () async {
                                      HapticFeedback.lightImpact();

                                      var jsonResponse;
                                      token == null
                                          ? Navigate.pushPage(
                                              context, Loginregister())
                                          : await Api.islike(
                                                  widget.id, userid, token)
                                              .then((value) => ({
                                                    jsonResponse =
                                                        jsonDecode(value.body),
                                                    print(
                                                        'message${jsonResponse['message']}'),
                                                    if (value.statusCode == 200)
                                                      {
                                                        if (jsonResponse[
                                                                'message'] ==
                                                            "Like Post Success")
                                                          {
                                                            setState(() {
                                                              islike =
                                                                  jsonResponse[
                                                                          'data']
                                                                      [
                                                                      'isLike'];

                                                              likeCount++;
                                                            }),
                                                          }
                                                        else if (jsonResponse[
                                                                'message'] ==
                                                            "UnLike Post Success")
                                                          {
                                                            setState(() {
                                                              islike =
                                                                  jsonResponse[
                                                                          'data']
                                                                      [
                                                                      'isLike'];

                                                              likeCount--;
                                                            }),
                                                          }
                                                      }
                                                  }));
                                      print("กดlike");
                                    },
                                  ),
                            PostButton(
                              icon: Icon(
                                MdiIcons.commentOutline,
                                color: MColors.primaryBlue,
                                size: 20.0,
                              ),
                              label: '$commentCount ความคิดเห็น',
                              onTap: () => print('Comment'),
                            ),
                            PostButton(
                              icon: Icon(
                                Icons.share,
                                color: MColors.primaryBlue,
                                size: 25.0,
                              ),
                              label: '$shareCount แชร์',
                              onTap: () => print('Share'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3,
            ),
          ],
        ),
      ),
    );
  }
}
