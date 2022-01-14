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
import 'package:mfp_app/model/commentlistmodel.dart';
import 'package:mfp_app/model/post_details_model.dart';
import 'package:mfp_app/model/searchpostlistModel.dart';
import 'package:http/http.dart' as Http;
import 'package:mfp_app/utils/app_theme.dart';
import 'package:mfp_app/utils/router.dart';
import 'package:mfp_app/utils/timeutils.dart';
import 'package:mfp_app/view/Auth/login-register.dart';
import 'package:mfp_app/view/Profile/profile.dart';
import 'package:mfp_app/view/Search/search.dart';
import 'package:mfp_app/view/Today/story_page.dart';

class PostDetailsSC extends StatefulWidget {
  final String postid;
  final String authorposttext;
  final String posttitle;
  final String subtitle;
  final DateTime dateTime;
  final List gallery;
  int likeCount;
  final int commentCount;
  final int shareCoun;
  final String userimage;
  final String pageid;
  final String pageimage;
  final String pagename;
  final bool isFollow;
  final String pageUsername;
  final bool isOfficial;
  final bool onfocus;
  final story;
  final String type;

  PostDetailsSC(
      {Key key,
      this.postid,
      this.authorposttext,
      this.posttitle,
      this.subtitle,
      this.dateTime,
      this.gallery,
      this.likeCount,
      this.commentCount,
      this.shareCoun,
      this.userimage,
      this.pageid,
      this.pageimage,
      this.pagename,
      this.isFollow,
      this.pageUsername,
      this.isOfficial,
      this.onfocus,
      this.type,
      this.story})
      : super(key: key);

  @override
  _PostDetailsSCState createState() => _PostDetailsSCState();
}

class _PostDetailsSCState extends State<PostDetailsSC> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  var datagetuserprofile;

  var datapostsearch;

  var userid = "";

  var token = "";

  var mode = "";

  var postimage = "";
  var  maxLines = 5;

  var userprofileimage = "";
  Future futuregetpostdetiail;

  bool postloading = true;
  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  var loading = true;
  var dataht;

  List<CommentlistModel> listModel = [];
  List<PostDetailsModel> postdetailslist = [];

  TextEditingController _commentController = TextEditingController();
  TextEditingController _commenteditController = TextEditingController();

  bool islikepost = false;
  bool idedit = false;
  var jsonResponse;
  bool onref = false;
  StreamController _commerntController;
  StreamController _postdetailController;
  var pagename = "";
  Future futuregetpostdetail;

  @override
  void didChangeDependencies() {
    setState(() {
      Api.getcommentlist(widget.postid, userid, token);
      Api.getstory(widget.postid);
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    ////(widget.postid);
    Future.delayed(Duration.zero, () async {
      // //('Futuredelayed');
      //--token
      token = await Api.gettoke();
      // //('tokenhome$token');
      //--mode
      mode = await Api.getmodelogin();
      // //('mode$mode');
      //--userid
      userid = await Api.getmyuid();
      // //('userid$userid');
      if (token == null) {
        setState(() {
          loading = false;
        });
      }
      //---getuserprofile
      await Api.getuserprofile(userid).then((responseData) async => ({
            setState(() {
              loading = true;
            }),
            if (responseData.statusCode == 200)
              {
                datagetuserprofile = jsonDecode(responseData.body),
                setState(() {
                  userprofileimage = datagetuserprofile["data"]["imageURL"];
                }),
                setState(() {
                  loading = false;
                }),
              }
            else
              {
                setState(() {
                  loading = false;
                }),
              }
          }));
      //--
     futuregetpostdetail = Api.getstory(widget.postid).then((responseData) async => ({
            setState(() {
              postloading = true;
            }),
            if (responseData.statusCode == 200)
              {
                jsonResponse = jsonDecode(responseData.body),
                // //('jsonResponse$jsonResponse'),
                for (Map i in jsonResponse["data"])
                  {
                    setState(() {
                      pagename = i['page'][0]['name'];
                    }),

                    postdetailslist.add(PostDetailsModel.fromJson(i)),
                    _postdetailController.add(responseData),

                    // var stroycoverImage= i["coverImage"];
                  },
                // //("Response  :$storytestreplaceAll"),
                // //('titalpost$titalpost'),
                setState(() {
                  postloading = false;
                }),
              }
            else if (responseData.statusCode == 400)
              {}
          }));
      //--getcommentlist
      await Api.getcommentlist(widget.postid, userid, token)
          .then((responseData) => ({
                // setState(() {
                //   loading = true;
                // }),
                // //('getHashtagData'),
                if (responseData.statusCode == 200)
                  {
                    dataht = jsonDecode(responseData.body),
                    // //("comlist${dataht["data"]}"),
                    for (Map i in dataht["data"])
                      {
                        setState(() {
                          listModel.add(CommentlistModel.fromJson(i));
                          _commerntController.add(responseData);
                        }),
                        // //('listModel${listModel.length}'),
                      },
                    // loading = false,
                  }
              }));
      //--.
      await Api.postsearch(userid, token, widget.postid, mode)
          .then((responseData) => ({
                // setState(() {
                //   loading = true;
                // }),
                // //('postsearch'),
                if (responseData.statusCode == 200)
                  {
                    datapostsearch = jsonDecode(responseData.body),
                    // //('checkislike$datapostsearch'),
                    for (Map i in dataht["data"])
                      {
                        // //('islike${i["isLike"]}'),
                        if (i["isLike"] == false)
                          {
                            setState(() {
                              islikepost = false;
                            }),
                            // //('islike$islikepost'),
                          }
                        else if (i["isLike"] == true)
                          {
                            setState(() {
                              islikepost = true;
                            }),
                            // //('islike$islikepost'),
                          }
                      },
                  }
              }));
    });
    _commerntController = new StreamController();
    _postdetailController = new StreamController();
    super.initState();
  }

  Future sendcomment(String postid, String mytoken, String mag, String myuid,
      String mode) async {
    // //('sendcomment');

    var url = Uri.parse("${Api.url}api/post/$postid/comment");
    final headers = {
      "userid": myuid,
      "mode": mode,
      "content-type": "application/json",
      "accept": "application/json",
      "authorization": "Bearer $mytoken",
    };
    Map data = {
      "commentAsPage": myuid,
      "comment": mag,
    };
    var body = jsonEncode(data);

    final responseData = await Http.post(
      url,
      headers: headers,
      body: body,
    );
    // //('body$body');
    // //('responseDatacommentlist${responseData.body}');
    final jsonResponse = jsonDecode(responseData.body);
    if (responseData.statusCode == 200) {
      // //(jsonResponse['status']);
      if (jsonResponse['status'] == 1) {
        setState(() {
          onref = true;
        });
      }
    }
  }

  Future<Null> _handleRefresh() async {
    setState(() {
      listModel.clear();
    });
    Api.getcommentlist(widget.postid, userid, token).then((responseData) => ({
          // setState(() {
          //   loading = true;
          // }),
          // //('getHashtagData'),
          if (responseData.statusCode == 200)
            {
              dataht = jsonDecode(responseData.body),
              // //("comlist${dataht["data"]}"),
              for (Map i in dataht["data"])
                {
                  setState(() {
                    listModel.add(CommentlistModel.fromJson(i));
                    _commerntController.add(responseData);
                  }),
                  // //('listModel${listModel.length}'),
                },
              setState(() {
                // loading = false;
                onref = false;
              }),
            }
        }));
     
  }
  
  
  @override
  Widget build(BuildContext context) {
    if (onref == true) {
      _handleRefresh();
    }
    // //(pagename);
    return loading == true
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                color: MColors.primaryColor,
              ),
            ))
        : Container(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                body: RefreshIndicator(
                  onRefresh: () => () async {
                    // //('RefreshIndicator');
                    HapticFeedback.mediumImpact();

                    _handleRefresh();
                  }(),
                  child: CustomScrollView(
                    controller: _trackingScrollController,
                    slivers: [
                      // primaryAppBar(
                      //     context,
                      //     token,
                      //     userid,
                      //     userprofileimage,
                      //     Search(),
                      //     ProfileSc(
                      //       userid: userid,
                      //       token: token,
                      //     )),
                      AppBardetail(
                        context,
                        "โพสต์ของ",
                        pagename == ""?"":pagename,
                        IconButton(
                          splashRadius: AppTheme.splashRadius,
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: MColors.primaryColor,
                          ),
                          
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),

                      ///-----------APPBAR-----------------//
                      postloading == true
                          ? SliverToBoxAdapter(child: CarouselLoading())
                          : SliverToBoxAdapter(
                              child: StreamBuilder(
                                stream: _postdetailController.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  return Builder(
                                      builder: (BuildContext context) {
                                    return ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      // padding: const EdgeInsets.all(8.0),
                                      scrollDirection: Axis.vertical,
                                      itemCount: postdetailslist.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final datapostdetail =
                                            postdetailslist[index];
                                        // pagename=datapostdetail.page[index].name;
                                        var likenumber = datapostdetail.likeCount;

                                        return PostList(
                                            datapostdetail.title,
                                            datapostdetail.detail,
                                            datapostdetail.page,
                                            datapostdetail.createdDate,
                                            datapostdetail.gallery,
                                            likenumber,
                                            datapostdetail.commentCount,
                                            datapostdetail.shareCount,
                                            widget.story,
                                            datapostdetail.id,
                                            datapostdetail);
                                      },
                                    );
                                  });
                                },
                              ),
                            ),
                      // SliverToBoxAdapter(
                      //   child:
                      // ),
                      SliverToBoxAdapter(
                        child: _buildCommentList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget PostList(
      String posttitle,
      String subtitle,
      List page,
      DateTime dateTime,
      List gallery,
      int likeCount,
      int commentCount,
      int shareCount,
    
      // String pageid,
      // String pageimage,
      // String pagename,
      // bool isFollow,
      // String pageUsername,
      // bool isOfficial,
      story,
        String postid,
        datapostdetail ) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        color: MColors.containerWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // gallery[0].signUrl != null
            //     ? gallery[0].imageUrl != null
            //         ? Hero(
            //             tag: "image" + gallery[0].signUrl,
            //             child: CachedNetworkImage(
            //               imageUrl: gallery[0].signUrl,
            //               placeholder: (context, url) =>
            //                   new CupertinoActivityIndicator(),
            //               errorWidget: (context, url, error) => Container(
            //                 decoration: BoxDecoration(
            //                   borderRadius:
            //                       BorderRadius.all(Radius.circular(8)),
            //                 ),
            //                 child: new Image.network(
            //                   gallery[0].signUrl,
            //                   filterQuality: FilterQuality.low,
            //                 ),
            //               ),
            //             ),
            //           )
            //         : SizedBox.shrink()
            //     : SizedBox.shrink(),
            gallery[0].imageUrl != null
                ? Hero(
                    tag: "image" + gallery[0].imageUrl,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://today-api.moveforwardparty.org/api${gallery[0].imageUrl}/image',
                      placeholder: (context, url) =>
                          new CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: new Image.network(
                          'https://today-api.moveforwardparty.org/api${gallery[0].imageUrl}/image',
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            // gallery.length != 0 ? _myAlbumCard(gallery) : SizedBox.shrink(),
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
                  widget.story != null
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                              onTap: () async {
                                Navigate.pushPage(
                                    context,
                                    StroyPageSc(
                                      postid:postid,
                                      titalpost: posttitle,
                                      imagUrl: gallery,
                                      type: widget.type,
                                      createdDate: dateTime,
                                      postby: page[0].name,
                                      imagepage: page[0].imageUrl,
                                      likeCount: likeCount,
                                      commentCount: commentCount,
                                      shareCount: shareCount,
                                      repostCount: 0,
                                      token: token,
                                      userid: userid,
                                      mode: mode,
                                    ));
                              },
                              child: textreadstory('อ่านสตอรี่...')),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: authorpost(
                              page[0].name,
                              context,
                              dateTime,
                              widget.pageid,
                              page[0].imageUrl,
                              page[0].name,
                              false,
                              "pageUsername",
                              false,
                              userid,
                              true),
                        ),
                      ),
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
                            PostButton(
                              icon: Icon(
                                islikepost != true
                                    ? Icons.favorite_outline
                                    : Icons.favorite,
                                color: MColors.primaryBlue,
                              ),
                              label: '${datapostdetail.likeCount} ถูกใจ',
                             width: 0.14,
                            containerwidth: 3.3,
                               onTap: () async {
                              HapticFeedback.lightImpact();
                              var jsonResponse;
                              token == null || token == ""
                                  ? Navigate.pushPage(
                                      context, Loginregister())
                                  : mode != "FB"
                                      ? await Api.islike(
                                              postid, userid, token, "")
                                          .then((value) => ({
                                                jsonResponse =
                                                    jsonDecode(value.body),
                                                // print(
                                                //     'message${jsonResponse['message']}'),
                                                if (value.statusCode == 200)
                                                  {
                                                    if (jsonResponse[
                                                            'message'] ==
                                                        "Like Post Success")
                                                      {
                                                        setState(() {
                                                          islikepost =
                                                              jsonResponse[
                                                                      'data']
                                                                  ['isLike'];
                                                          islikepost = true;
                                                          datapostdetail.likeCount++;
                                                        }),
                                                      }
                                                    else if (jsonResponse[
                                                            'message'] ==
                                                        "UnLike Post Success")
                                                      {
                                                        setState(() {
                                                          islikepost =
                                                              jsonResponse[
                                                                      'data']
                                                                  ['isLike'];
                                                          islikepost = false;
                                                         datapostdetail.likeCount--;
                                                        }),
                                                      }
                                                  }
                                              }))
                                      : await Api.islike(
                                              postid, userid, token, mode)
                                          .then((value) => ({
                                                jsonResponse =
                                                    jsonDecode(value.body),
                                                // print(
                                                //     'message${jsonResponse['message']}'),
                                                if (value.statusCode == 200)
                                                  {
                                                    if (jsonResponse[
                                                            'message'] ==
                                                        "Like Post Success")
                                                      {
                                                        setState(() {
                                                          islikepost =
                                                              jsonResponse[
                                                                      'data']
                                                                  ['isLike'];
                                                          datapostdetail.likeCount++;
                                                        }),
                                                      }
                                                    else if (jsonResponse[
                                                            'message'] ==
                                                        "UnLike Post Success")
                                                      {
                                                        setState(() {
                                                          islikepost =
                                                              jsonResponse[
                                                                      'data']
                                                                  ['isLike'];

                                                          datapostdetail.likeCount--;
                                                        }),
                                                      }
                                                  }
                                              }));
                              // print("กดlike");
                            },
                            ),
                            PostButton(
                              icon: Icon(
                                MdiIcons.commentOutline,
                                color: MColors.primaryBlue,
                              ),
                                 width: 0.24,
                                                        containerwidth: 3.1,
                              label: '$commentCount ความคิดเห็น',
                              onTap: () => {},
                            ),
                            PostButton(
                              icon: Icon(
                                Icons.share,
                                color: MColors.primaryBlue,
                              ),
                           width: 0.12,
                            containerwidth: 3.3,

                              label: '$shareCount แชร์',
                              onTap: null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  token == "" || token == null
                      ? Container()
                      : Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: userprofileimage != null
                                    ? NetworkImage(
                                        'https://today-api.moveforwardparty.org/api$userprofileimage/image')
                                    : NetworkImage(
                                        'https://via.placeholder.com/150'),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Container(
                                      width: MediaQuery.of(context).size.width / 1.3,
                                 height: maxLines * 19.0,
                                       decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffDEDEDE),
                                  ),
                                  color: MColors.primaryWhite,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9.0),
                                  ),
                                ),
                    child:  new ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 300.0,
        ),
                      child: LayoutBuilder(
                        builder: (context, size){
                          TextSpan text = new TextSpan(
                            text: _commentController.text,
                            // style: yourTextStyle,
                          );
                    
                          TextPainter tp = new TextPainter(
                              text: text,
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                          );
                          tp.layout(maxWidth: size.maxWidth);
                    
                          int lines = (tp.size.height / tp.preferredLineHeight).ceil();
                          int maxLines = 10;
                          print('height${tp.size.height}');
                    
                          return TextField(
                           controller: _commentController,
                                  autofocus: widget.onfocus,
                                  onChanged: (String value) {
                                    _commenteditController.text = value;
                                    //(value);
                                  },
                            maxLines: lines < maxLines ? null : maxLines,
                            decoration: InputDecoration(
                                    // contentPadding: const EdgeInsets.all(13.0),
                                    hintText: "เขียนความคิดเห็น",
                                            border: InputBorder.none,
                                
                                    suffixIcon: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // added line
                                      mainAxisSize:
                                          MainAxisSize.min, // added line
                                      children: <Widget>[
                                        IconButton(
                                          splashRadius: AppTheme.splashRadius,
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.black,
                                          ),
                                          onPressed: () async {
                                            await sendcomment(
                                                widget.postid,
                                                token,
                                                _commentController.text,
                                                userid,
                                                mode);
                                            setState(() {
                                              _commentController.clear();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                            // style: yourTextStyle,
                          );
                        }
                      ),
                    ),
                  ),
                            ),
                          ],
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

  Widget _buildCommentList() {
    return StreamBuilder(
      stream: _commerntController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: listModel.length,
          itemBuilder: (BuildContext context, int index) {
            var data = listModel[index];
            _commenteditController.text = data.comment;
            var commentid = data.id;

            return new InkWell(
              onTap: () async {
                data.user.id == userid
                    ? showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  child: const Text('Edit'),
                                  onPressed: () {
                                    setState(() {
                                      idedit = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('Delete',
                                      style: TextStyle(
                                        color: Colors.red,
                                      )),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            new CupertinoAlertDialog(
                                              title: new Text(
                                                "Delete Comment",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: [
                                                CupertinoDialogAction(
                                                  isDefaultAction: true,
                                                  child: new Text("Cancel"),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                CupertinoDialogAction(
                                                    child: new Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () async {
                                                      Api.deletecomment(
                                                              widget.postid,
                                                              token,
                                                              commentid,
                                                              userid,
                                                              mode)
                                                          .then((value) => ({
                                                                if (value[
                                                                        'status'] ==
                                                                    1)
                                                                  {
                                                                    setState(
                                                                        () {
                                                                      onref =
                                                                          true;
                                                                    }),
                                                                  }
                                                              }));
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.check,
                                                              color: MColors
                                                                  .primaryWhite,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text('Success')
                                                          ],
                                                        ),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2500),
                                                      ));
                                                    }),
                                              ],
                                            ));
                                  },
                                )
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),)
                    : Container();
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                // widget.data['toCommentID'] == null ? EdgeInsets.all(8.0) : EdgeInsets.fromLTRB(34.0,8.0,8.0,8.0),
                child: Stack(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                          child: Container(
                            width: 48,
                            // widget.data['toCommentID'] == null ? 48 : 40,
                            height: 48,
                            // widget.data['toCommentID'] == null ? 48 : 40,
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: data.user.imageUrl != null
                                  ? NetworkImage(
                                      "https://today-api.moveforwardparty.org/api${data.user.imageUrl}/image")
                                  : NetworkImage(
                                      'https://via.placeholder.com/150'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        data.user.displayName,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            color: MColors.primaryBlue),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        data.comment,
                                        maxLines: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: MColors.primaryBlue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              width: MediaQuery.of(context).size.width - 90,
                              // widget.size.width- (widget.data['toCommentID'] == null ? 90 : 110),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffDEDEDE),
                                ),
                                color: MColors.primaryWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 2.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        Api.islikecomment(widget.postid, userid,
                                                token, commentid, mode)
                                            .then((value) => ({
                                                  jsonResponse =
                                                      jsonDecode(value.body),
                                                  //print('message${jsonResponse['message']}'),
                                                  if (value.statusCode == 200)
                                                    {
                                                      if (jsonResponse[
                                                              'message'] ==
                                                          "Like Post Comment Success")
                                                        {
                                                          setState(() {
                                                            data.likeCount++;
                                                            data.isLike = true;
                                                          }),
                                                        }
                                                      else if (jsonResponse[
                                                              'message'] ==
                                                          "UnLike Post Comment Success")
                                                        {
                                                          setState(() {
                                                            data.likeCount--;
                                                            data.isLike = false;
                                                          }),
                                                        }
                                                    }
                                                }));
                                      },
                                      child: Text(
                                        'ถูกใจ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: MColors.primaryBlue),
                                        // style:TextStyle(fontWeight: FontWeight.bold,color:_currentMyData.myLikeCommnetList != null && _currentMyData.myLikeCommnetList.contains(widget.data['commentID']) ? Colors.blue[900] : Colors.grey[700])
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            new CupertinoAlertDialog(
                                              title: new Text(
                                                "ลบ คอมเม้นต์",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: [
                                                CupertinoDialogAction(
                                                  isDefaultAction: true,
                                                  child: new Text("ยกเลิก"),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                CupertinoDialogAction(
                                                    child: new Text(
                                                      "ลบ",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () async {
                                                      Api.deletecomment(
                                                              widget.postid,
                                                              token,
                                                              commentid,
                                                              userid,
                                                              mode)
                                                          .then((value) => ({
                                                                if (value[
                                                                        'status'] ==
                                                                    1)
                                                                  {
                                                                    setState(
                                                                        () {
                                                                      onref =
                                                                          true;
                                                                    }),
                                                                  }
                                                              }));
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.check,
                                                              color: MColors
                                                                  .primaryWhite,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text('สำเร็จ')
                                                          ],
                                                        ),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2500),
                                                      ));
                                                    }),
                                              ],
                                            ));

                                      },
                                      child: Text(
                                        'ลบ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: MColors.primaryBlue),
                                        // style:TextStyle(fontWeight: FontWeight.bold,color:_currentMyData.myLikeCommnetList != null && _currentMyData.myLikeCommnetList.contains(widget.data['commentID']) ? Colors.blue[900] : Colors.grey[700])
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      TimeUtils.readTimestamp(data
                                          .createdDate.millisecondsSinceEpoch),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: MColors.primaryBlue,
                                          fontFamily:
                                              AppTheme.FontAnakotmaiLight,
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
