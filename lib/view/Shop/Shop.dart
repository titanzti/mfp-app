import 'package:flutter/material.dart';
import 'package:mfp_app/Api/Api.dart';
import 'package:mfp_app/allWidget/allWidget.dart';
import 'package:mfp_app/allWidget/allWidget.dart';

class ShopSC extends StatefulWidget {
  // ShopSC({Key? key}) : super(key: key);

  @override
  _ShopSCState createState() => _ShopSCState();
}

class _ShopSCState extends State<ShopSC> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  var token;

  var userid;

  var userimageUrl;

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
               
    });
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
              primaryAppBar(context, token,userid, userimageUrl),

              ///-----------APPBAR-----------------//

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
                          itemCount: 50,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return ListTile(
                              title: Text('test$index'),
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

    // Scaffold(
    //   appBar: AppBar(),

    //   body:

    // );
  }
}
