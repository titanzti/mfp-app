import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:mfp_app/constants/colors.dart';
import 'package:mfp_app/model/searchpostlistModel.dart';
import 'package:mfp_app/utils/app_theme.dart';
import 'package:mfp_app/utils/timeutils.dart';
import 'package:url_launcher/url_launcher.dart';

class StroyPageSc extends StatefulWidget {
  final String postid;
  final String titalpost;
  final List<GalleryPostSearchModel> imagUrl;
  final String type;
  final DateTime createdDate;
  final String postby;
  final String imagepage;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int repostCount;
  StroyPageSc({
    Key key,
    this.postid,
    this.titalpost,
    this.imagUrl,
    this.type,
    this.createdDate,
    this.postby,
    this.imagepage,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.repostCount,
  }) : super(key: key);

  @override
  _StroyPageScState createState() => _StroyPageScState();
}

class _StroyPageScState extends State<StroyPageSc> {
  var dataht;
  var storytest, storyimage;

  String story1;
  String base64Image;
  var storytestreplaceAll;
  Widget image;
  List<GalleryPostSearchModel> imagelist = [];
  String type = "";

  Future getProfileSS(String id) async {
    print('getProfileSS');
    try {
      var url =
          Uri.parse("https://today-api.moveforwardparty.org/api/post/search");
      final headers = {
        "content-type": "application/json",
      };
      Map data = {
        "limit": 10,
        "count": false,
        "whereConditions": {"_id": id}
      };
      var body = jsonEncode(data);

      var responseRequest = await http.post(url, headers: headers, body: body);

      if (responseRequest.statusCode == 200) {
        final jsonResponse = jsonDecode(responseRequest.body);
        setState(() {
          var date1 = jsonResponse["data"];

          for (var i in date1) {
            storytest = i["story"]["story"];
            storyimage = i["story"]["coverImage"];

            storytestreplaceAll = storytest.replaceAll("<create-text>", "");

            print('storytest${storytest}');
            // print(i);
          }
        });
        List<int> imageBytes = storyimage.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
        // print('base64Image$base64Image');

        final _byteImage = Base64Decoder().convert(base64Image);
        image = Image.memory(_byteImage);
        print('imageBase64Decoder$image');

        print("Response status :${jsonResponse.statusCode}");
      }

      // return responsepostRequest;
    } catch (e) {}
  }

  @override
  void initState() {
    getProfileSS(widget.postid);
    imagelist = widget.imagUrl;

    super.initState();
  }
void _launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}
  @override
  Widget build(BuildContext context) {
    if (widget.type == "GENERAL") {
      type = "ทั่วไป";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MColors.primaryWhite,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.titalpost,
          style: TextStyle(
              color: Color(0xff0C3455),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: MColors.primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: storytestreplaceAll == null
              ? Center(
                  child: Center(
                      child: CircularProgressIndicator(
                    color: MColors.primaryColor,
                  )),
                )
              : Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.network("${imagelist[0].signUrl}",
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              colorBlendMode: BlendMode.modulate),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.9,
                            child: Center(
                                child: Column(
                                  mainAxisAlignment :MainAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   height:
                                //       MediaQuery.of(context).size.height / 10.0,
                                // ),
                                Center(
                                  child: Container(
                                    // color: Colors.grey[800],
                                    width: MediaQuery.of(context).size.width,
                                    // height:
                                    //     MediaQuery.of(context).size.height / 10,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.titalpost,
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: AppTheme.FontAnakotmaiBold,
                                                color: MColors.primaryWhite,
                                                fontSize: AppTheme.TitleTextSize
                                                ),
                                          ),
                                             Padding(
                                               padding: const EdgeInsets.only(left: 30,right: 30),
                                               child: Divider(
                                    color: MColors.primaryWhite,
                                    height: 10,
                                    thickness: 2.0),
                                             ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            
                             
                                // SizedBox(
                                //   height:
                                //       MediaQuery.of(context).size.height / 5.5,
                                // ),
                               
                              ],
                            ),
                            ),
                          ),
                        ],
                      ),
                       Container(
                                  alignment: Alignment.bottomCenter,
                                  color: Colors.grey[800],
                                  height:
                                      MediaQuery.of(context).size.height / 20.0,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 40),
                                      ),
                                      Text(
                                        widget.commentCount.toString(),
                                        //'${nDataList.post.commentCount}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.comment,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          print('กด');
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Text(
                                        widget.repostCount.toString(),
                                        //'${nDataList.post.repostCount}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          print('กด');
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Text(
                                        widget.likeCount.toString(),
                                        //'${nDataList.post.likeCount}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize:  20),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite_border,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          print('กด');
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Text(
                                        widget.shareCount.toString(),
                                        //'${nDataList.post.shareCount}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.share_outlined,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          print('กด');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                           
                                Center(
                                  child: Text(
                                    'มีการเติมเต็ม 0 รายการ',
                                    style: TextStyle(
                                      fontFamily: AppTheme.FontAnakotmaiMedium,
                                                color: MColors.textDark,
                                                fontSize: AppTheme.BodyTextSize
      
                                        ),
                                  ),
                                ),
                                 Divider(
                        color: Colors.grey[200],
                        height: 3,
                        thickness: 6.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 9.0,
                        // color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(
                                      "https://today-api.moveforwardparty.org/api${widget.imagepage}/image")),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 45.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$type ${TimeUtils.readTimestamp(widget.createdDate.millisecondsSinceEpoch)}",
                                    style: TextStyle(
                                            fontFamily: AppTheme.FontAnakotmaiBold,
                                                color: MColors.textDark,
                                                fontSize: AppTheme.BodyTextSize
      
                                        ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'เผยแพร่โดย:${widget.postby}',
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                            fontFamily: AppTheme.FontAnakotmaiBold,
                                                color: MColors.textGrey,
                                                fontSize: AppTheme.BodyTextSize12
      
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
      
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Html(
                          data: """
                    ${storytestreplaceAll == null ? Text('ไม่มีStroy') : storytestreplaceAll}
                    """,
                    defaultTextStyle :TextStyle(fontFamily: AppTheme.FontAnakotmaiLight,color: MColors.textDark),
                          // padding: EdgeInsets.all(8.0),
                          onLinkTap: (url) async{
                            _launchURL(url);
                            print("Opening $url...");
                          },
                          // customRender: (node, children) {
                          //   if (node is dom.Element) {
                          //     switch (node.localName) {
                          //       case "custom_tag": // using this, you can handle custom tags in your HTML
                          //         return Column(children: children);
                          //     }
                          //   }
                          // },
                        ),
                      ),
                      // Text('data'),
                    ],
                  ),
                ),
          //  Text("$storytest"),
        ),
      ),
    );
  }
}
