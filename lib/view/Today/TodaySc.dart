import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mfp_app/Api/Api.dart';
import 'package:mfp_app/Api/apipost.dart';
import 'package:mfp_app/constants/colors.dart';
import 'package:mfp_app/model/RecommendedUserPageModel.dart';
import 'package:mfp_app/model/postModel.dart';
import 'package:mfp_app/model/searchpostlistModel.dart';
import 'package:mfp_app/allWidget/CarouselsLoading.dart';
import 'package:mfp_app/allWidget/allWidget.dart';
import 'package:mfp_app/allWidget/fontsize.dart';
import 'dart:io' show Platform;
import 'package:mfp_app/allWidget/PostButton.dart';

import 'package:mfp_app/view/Today/PostDetailsSc.dart';

class TodaySc extends StatefulWidget {
  @override
  _TodayScState createState() => _TodayScState();
}

class _TodayScState extends State<TodaySc> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();
  ScrollController _scrollController = ScrollController();

  int _currentMax = 5;
  Future refpost;
  String messger = "";

  StreamController _postsController;
  List<PostSearchModel> listModelPostClass = [];
  List<EmergencyEventsContent> listemergencyEvents = [];
  List<RecomUserPageModel> listRecomUserPageModel = [];

  bool loading = true;
  var dataht, datapostlist, myuid, dataht1;
  Future getDataPostListFuture;
  bool isLoading = true;
  bool isLoadingHastag = true;
  int _page = 0;
  bool _isLoadMoreRunning = false;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  void dispose() {
    _trackingScrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _scrollController.addListener(_loadMore);
      //   () async {
      //   if (_scrollController.position.pixels ==
      //       _scrollController.position.maxScrollExtent) {
      //     print('At the End');
      //     setState(() {
      //       _currentMax = _currentMax + 5;
      //       Api.getPostList(_currentMax).then((value) => {
      //             if (value.statusCode == 200)
      //               {
      //                 datapostlist = jsonDecode(value.body),
      //                 for (Map i in datapostlist["data"])
      //                   {
      //                     listModelPostClass.add(PostSearchModel.fromJson(i)),
      //                     _postsController.add(value),
      //                   },
      //               }
      //           });

      //       //-------------------------------
      //       Api.getRecommendedUserPage().then((value) => {
      //             listRecomUserPageModel.clear(),
      //             if (value.statusCode == 200)
      //               {
      //                 datapostlist = jsonDecode(value.body),
      //                 for (Map i in datapostlist["data"])
      //                   {
      //                     listRecomUserPageModel
      //                         .add(RecomUserPageModel.fromJson(i)),
      //                   },
      //               }
      //           });
      //     });
      //   }
      // });
      //-----------------------------//
      Api.getPostemergencyEventsList().then((responseData) => ({
            print('getPostList'),
            setState(() {
              isLoadingHastag = true;
            }),
            if (responseData.statusCode == 200)
              {
                datapostlist = jsonDecode(responseData.body),
                for (Map i in datapostlist["data"]["emergencyEvents"]
                    ["contents"])
                  {
                    setState(() {
                      listemergencyEvents
                          .add(EmergencyEventsContent.fromJson(i));
                    }),
                  },
                setState(() {
                  isLoadingHastag = false;
                }),
              }
            else if (responseData.statusCode == 400)
              {}
          }));

      refpost = Api.getPostList(_currentMax).then((value) => {
            if (value.statusCode == 200)
              {
                setState(() {
                  isLoading = true;
                }),
                datapostlist = jsonDecode(value.body),
                for (Map i in datapostlist["data"])
                  {
                    listModelPostClass.add(PostSearchModel.fromJson(i)),
                    _postsController.add(value),
                  },
                setState(() {
                  isLoading = false;
                }),
              }
          });
      //-------------//
      Api.getRecommendedUserPage().then((value) => {
            if (value.statusCode == 200)
              {
                datapostlist = jsonDecode(value.body),
                for (Map i in datapostlist["data"])
                  {
                    listRecomUserPageModel.add(RecomUserPageModel.fromJson(i)),
                  },
              }
          });

      _postsController = new StreamController();
    });
  }

  Widget BuildVideorecom() {
    return Card(
      child: Container(
        width: double.infinity,
        height: 350.84,
        // color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 20),
              child:
                  texttitleVideorecommend("วิดีโอสำหรับคุณโดยเฉพาะ", context),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 2),
              child: textsubVideorecommend(
                  "เพลิดเพลินกับเพลย์ลิสต์ที่ปรับให้เหมาะกับคุณจาก Youtube",
                  context),
            ),
            SizedBox(
              height: 240.0,
              child: Builder(
                builder: (BuildContext context) {
                  return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return Videorecommend();
                      });
                },
              ),
            ),
            Center(
              child: Text(
                "ดูวิดีโอเพิ่มเติมบน Youtube",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    new Future.delayed(const Duration(seconds: 3));
    setState(() {
      listemergencyEvents.clear();
      listModelPostClass.clear();
      listRecomUserPageModel.clear();
    });
    try {
      await Api.getPostemergencyEventsList().then((responseData) => ({
            print('getPostList'),
            if (responseData.statusCode == 200)
              {
                datapostlist = jsonDecode(responseData.body),
                for (Map i in datapostlist["data"]["emergencyEvents"]
                    ["contents"])
                  {
                    setState(() {
                      listemergencyEvents
                          .add(EmergencyEventsContent.fromJson(i));
                    }),
                  },
              }
            else if (responseData.statusCode == 400)
              {}
          }));
      //-----------------------------------------------
      await Api.getPostList(_currentMax).then((value) => {
            if (value.statusCode == 200)
              {
                datapostlist = jsonDecode(value.body),
                for (Map i in datapostlist["data"])
                  {
                    setState(() {
                      listModelPostClass.add(PostSearchModel.fromJson(i));
                      _postsController.add(value);
                    }),
                  },
              }
          });
      //-----------------------------------------------

      await Api.getRecommendedUserPage().then((value) => {
            if (value.statusCode == 200)
              {
                datapostlist = jsonDecode(value.body),
                for (Map i in datapostlist["data"])
                  {
                    listRecomUserPageModel.add(RecomUserPageModel.fromJson(i)),
                  },
              }
          });
    } finally {}
  }

  void _loadMore() async {
    if (_isLoadMoreRunning == false &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      print('AT end');
      setState(() {
        _currentMax = _currentMax + 5;

        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      try {
        Api.getPostList(_currentMax).then((value) => {
              if (value.statusCode == 200)
                {
                  setState(() {
                    isLoading = true;
                  }),
                  datapostlist = jsonDecode(value.body),
                  for (Map i in datapostlist["data"])
                    {
                      listModelPostClass.add(PostSearchModel.fromJson(i)),
                      _postsController.add(value),
                    },
                  setState(() {
                    isLoading = false;
                  }),
                }
            });
      } catch (err) {
        print('Something went wrong!');
      }
    }
    setState(() {
      _isLoadMoreRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () => () async {
              HapticFeedback.mediumImpact();
              print('RefreshIndicator');
              await _handleRefresh();
              await Api.getRecommendedUserPage();
              await Api.getPostList(_currentMax);
            }(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              slivers: [
                Platform.isAndroid
                    ? SliverToBoxAdapter(
                        child: SizedBox.shrink(
                        child: Container(),
                      ))
                    : primaryAppBar(context),

                ///-----------APPBAR-----------------//
                isLoadingHastag
                    ? SliverToBoxAdapter(child: CarouselLoading())
                    : SliverToBoxAdapter(
                        child: Carouselslider(listemergencyEvents, context)),

                ///-----------เลื่อนสไลด์-----------------//
                listModelPostClass.length == 0
                    ? SliverToBoxAdapter(child: Container())
                    : SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          color: MColors.primaryGrey,
                          child: Center(
                            child: titletimeline("ไทม์ไลน์"),
                          ),
                        ),
                      ),

                ///-----------คำว่าไทม์ไลน์-----------------//

                isLoading == true
                    ? SliverToBoxAdapter(child: CarouselLoading())
                    : SliverToBoxAdapter(
                        child: StreamBuilder(
                          stream: _postsController.stream,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CarouselLoading());
                            }
                            // if (snapshot.connectionState == ConnectionState.none) {
                            //   return Center(child: Text(messger));
                            // }
                            return Builder(
                              builder: (BuildContext context) {
                                return ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    // padding: const EdgeInsets.all(8.0),
                                    scrollDirection: Axis.vertical,
                                    itemCount: listModelPostClass.length,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      // if (listModelPostClass.length == 0) {
                                      //   return Center(
                                      //       child: CupertinoActivityIndicator());
                                      // }
                                      final nDataList1 =
                                          listModelPostClass[index];

                                      if (index == listModelPostClass.length - 2) {
                                        return BuildVideorecom();
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
                                        nDataList1.post.title,
                                        nDataList1.post.detail,
                                        nDataList1.page.name,
                                        nDataList1.page.createdDate,
                                        nDataList1.post.gallery,
                                        nDataList1.post.likeCount,
                                        nDataList1.post.commentCount,
                                        nDataList1.post.shareCount,
                                         nDataList1.post.id,
                                      );
                                    });
                              },
                            );
                          },
                        ),
                      ),
                // when the _loadMore function is running

                ///-----------ListViewPost-----------------//

                // /-----------SliverListปิดไปก่อนได้----------------//
                listModelPostClass.length == 0
                    ? SliverToBoxAdapter(child: Container())
                    : SliverToBoxAdapter(child: BuildRecommendedUserPage()),

                if (_isLoadMoreRunning == true)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _myAlbumCard(List<Gallery> list) {
    if (list.length >= 4) {
      return Container(
        height: 280,
        width: double.infinity,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getItems(list[0].signUrl, list[1].signUrl, 0),
              getItems(list[2].signUrl, list[3].signUrl, list.length - 4),
            ],
          ),
        ),
      );
    } else if (list.length >= 3) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 340,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey, width: 0.2)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  getItems(list[0].signUrl, list[1].signUrl, 0),
                  Expanded(
                    child: getItems(list[2].signUrl, list[3].signUrl ?? "",
                        list.length - 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (list.length >= 2) {
      return Container(
        height: 340,
        width: double.infinity,
        color: Colors.black,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getItems(list[0].signUrl, list[1].signUrl, 0),
            ],
          ),
        ),
      );
    } else if (list.length >= 1) {
      return Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.only(
              //       left: 10.0, top: 2),
              //   child: Text(
              //     name,
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 14,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              list[0].signUrl != null
                  ? CachedNetworkImage(
                      imageUrl: list[0].signUrl,
                      placeholder: (context, url) =>
                          new CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: new Image.network(
                          list[0].signUrl,
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      );
    }
  }

  getItems(img_path, img_path2, count) {
    return Container(
      width: double.infinity,
      child: Row(
        // crossAxisAlignment :CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // SizedBox(width: 5,),
          ClipRRect(
            child: Image.network(
              img_path,
              height: 140,
              width: 190,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          ),
          SizedBox(
            width: 11,
          ),
          (count > 0)
              ? Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    ClipRRect(
                      // borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),),
                      child: Image.network(
                        img_path2,
                        height: 140,
                        width: 190,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                    (count > 0)
                        ? Positioned(
                            child: Container(
                              height: 140,
                              width: 190,
                              decoration: BoxDecoration(color: Colors.black38),
                              child: Center(
                                child: Text(
                                  "$count +",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center()
                  ],
                )
              : ClipRRect(
                  child: Image.network(
                    img_path2,
                    height: 140,
                    width: 190,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                  ),
                ),
        ],
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
      String postid
      ) {
    return InkWell(
      onTap: () {
        Navigator.push( context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PostDetailsSC(posttitle: posttitle,
                                        subtitle:subtitle,
                                        authorposttext:authorposttext,
                                        dateTime:dateTime,
                                        gallery:gallery,
                                        likeCount:likeCount,
                                        commentCount:commentCount,
                                        shareCoun:shareCount,
                                        id: postid,
              
              );
            },
          ),
        );
      },
      child: Container(
        width: 200,
        color: MColors.containerWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gallery.length != 0 ? _myAlbumCard(gallery) : SizedBox.shrink(),
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
                      authorpost(authorposttext, context),
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
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
               decoration: BoxDecoration(
                color: MColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_outline,
                size: 10.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                '$likeCount ถูกใจ',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            Text(
              '$commentCount ความคิดเห็น',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              '$shareCount  แชร์',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            )
          ],
        ),
        const Divider(),
        Row(
          children: [
          PostButton(
              icon: Icon(
                Icons.favorite_outline,
                color: MColors.primaryBlue,
                size: 20.0,
              ),
              label: 'ถูกใจ',
              onTap: () => print('Like'),
            ),
            PostButton(
              icon: Icon(
                MdiIcons.commentOutline,
                color: MColors.primaryBlue,
                size: 20.0,
              ),
              label: 'ความคิดเห็น',
              onTap: () => print('Comment'),
            ),
            PostButton(
              icon: Icon(
                Icons.share,
                color: MColors.primaryBlue,
                size: 25.0,
              ),
              label: 'แชร์',
              onTap: () => print('Share'),
            )
          ],
        ),
        SizedBox(
              height: 5,
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

  Widget Videorecommend(
      // String posttitle, String subtitle, String authorposttext,
      //   DateTime dateTime, List<Gallery> gallery,int likeCount,int commentCount,int shareCount
      ) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 300,
        height: 200,
        color: MColors.containerWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(gallery[0].signUrl),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'images/wightimage.jpg',
                        height: 123,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('อนาคตใหม่ - Future Forward'),
                        ),
                        // fixtextauthor(),
                        // authorpost(authorposttext, context),
                        // texttimetimestamp(dateTime),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildRecommendedUserPage() {
    return Card(
      child: Container(
        width: double.infinity,
        height: 500.84,
        // color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: texttitle("แนะนำให้ติดตามส.ส. กทม", context),
            ),
            SizedBox(
              height: 10,
            ),
            Builder(
              builder: (BuildContext context) {
                return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listRecomUserPageModel.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      var data = listRecomUserPageModel[index];
                      return Card(
                        child: Container(
                          child: ListTile(
                            leading: new CircleAvatar(
                              radius: 30,
                              backgroundImage: data.imageUrl != null
                                  ? NetworkImage(
                                      "https://today-api.moveforwardparty.org/api${data.imageUrl}/image")
                                  : NetworkImage(
                                      "https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png"),
                              backgroundColor: Colors.transparent,

                              // child: Container(
                              //   height: 81,
                              //   width: 347,
                              //   color: Colors.white,
                              //   child: Image.network(
                              //       "https://today-api.moveforwardparty.org/api${data.imageUrl}/image"),
                              // ),
                            ),
                            title: new Text(
                                '${data.displayName == null ? data.name : data.displayName}'),
                            subtitle: new Text(
                                '${data.pageUsername == null ? "" : data.pageUsername}'),
                          ),
                        ),
                      );
                    });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "ดูเพิ่มเติม",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Carouselslider(List<EmergencyEventsContent> emc, context) {
    return CarouselSlider(
      carouselController: _controller,
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
        height: 450,
        aspectRatio: 4 / 3,
        enableInfiniteScroll: true,
        initialPage: 0,
        viewportFraction: 0.99,
        scrollPhysics: BouncingScrollPhysics(),
        reverse: false,
        autoPlay: false,
        disableCenter: true,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: emc.map((emcs) {
        return Builder(
          builder: (BuildContext context) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Container(
                    // borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      "https://today-api.moveforwardparty.org/api${emcs.coverPageUrl}/image",
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      color: MColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: texthashtags(emcs.title),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'ดูเพิ่มเติม >',
                              style: TextStyle(
                                fontFamily: 'Anakotmai-Light',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: MColors.primaryWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: emc.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.2)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }).toList(),
    );
  }
}
