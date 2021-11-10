import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mfp_app/allWidget/allWidget.dart';
import 'package:mfp_app/allWidget/fontsize.dart';
import 'package:mfp_app/constants/colors.dart';
import 'package:mfp_app/model/searchpostlistModel.dart';

class PostDetailsSC extends StatefulWidget {
  final String id;
  final String image;
  final String authorposttext;
  final String posttitle;
  final String subtitle;
  final DateTime dateTime;
  final List<Gallery> gallery;
  final int likeCount;
  final int commentCount;
  final int shareCoun;
  const PostDetailsSC(
      {Key key,
      this.id,
      this.image,
      this.authorposttext,
      this.posttitle,
      this.subtitle,
      this.dateTime,
      this.gallery,
      this.likeCount,
      this.commentCount,
      this.shareCoun})
      : super(key: key);

  @override
  _PostDetailsSCState createState() => _PostDetailsSCState();
}

class _PostDetailsSCState extends State<PostDetailsSC> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            controller: _trackingScrollController,
            slivers: [
              primaryAppBar(context),
              AppBardetail(context, widget.authorposttext),

              ///-----------APPBAR-----------------//
              SliverToBoxAdapter(
                child: PostList(
                  widget.posttitle,
                  widget.subtitle,
                  widget.authorposttext,
                  widget.dateTime,
                  widget.gallery,
                  widget.likeCount,
                  widget.commentCount,
                  widget.shareCoun,
                ),
              ),

              ///-----------SliverListปิดไปก่อนได้----------------//
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return ListTile(
                             
                              leading:  new  CircleAvatar(
                          radius: 25.0,
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                          backgroundColor: Colors.transparent,
                        ),
                              title: Text('I like icecream$index'),
                              subtitle: Text('Icream is good for health'),
                              trailing: Icon(Icons.food_bank),
                            );
                          });
                    },
                  );
                }, childCount: 1),
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
      int shareCount) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PostDetailsSC(
                authorposttext: authorposttext,
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
            gallery[0].signUrl != null
                ? CachedNetworkImage(
                    imageUrl: gallery[0].signUrl,
                    placeholder: (context, url) =>
                        new CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: new Image.network(
                        gallery[0].signUrl,
                        filterQuality: FilterQuality.low,
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
                    child: UIlikecommentshear(
                        context, likeCount, commentCount, shareCount),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Container(
                          width: 300,
                          height: 80,
                          child: TextFormField(
                            onSaved: (String value) {},
                            onChanged: (String value) {
                              // _commenteditController.text =
                              //     value;
                              print(value);
                            },
                            // initialValue:
                            //     _commenteditController.text,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(20.0),
                              hintText: "เขียนความคิดเห็น",
                              suffixIcon: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // added line
                                mainAxisSize: MainAxisSize.min, // added line
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {},
                                  ),
                                ],
                              ),
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
}
