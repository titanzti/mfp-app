import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mfp_app/allWidget/sizeconfig.dart';
import 'package:mfp_app/constants/colors.dart';
import 'package:mfp_app/utils/app_theme.dart';
import 'package:mfp_app/view/Auth/login.dart';

class Loginregister extends StatefulWidget {
  Loginregister({Key key}) : super(key: key);

  @override
  _LoginregisterState createState() => _LoginregisterState();
}

class _LoginregisterState extends State<Loginregister>
    with TickerProviderStateMixin {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = brightness == Brightness.dark;
    final screenhight = MediaQuery.of(context).size.height;
    final statusbarheight = MediaQuery.of(context).padding.top;
 SizeConfig().init(context);

    return Container(
        color: MColors.primaryWhite,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: MColors.primaryWhite,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: isDarkModeOn
                  ? SystemUiOverlayStyle.dark.copyWith(
                      statusBarColor: Theme.of(context).primaryColor,
                    )
                  : SystemUiOverlayStyle.light.copyWith(
                      statusBarColor: Theme.of(context).primaryColor,
                    ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      alignment: Alignment.topLeft,
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
                    SizedBox(
                      height: screenhight /15.0,
                    ),
                    Center(
                      child: Container(
                         height: SizeConfig.screenHeight * 0.4,
                        //  width: SizeConfig.blockSizeHorizontal * 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('images/MFP-Logo-Verticle.png'),
                        )),
                      ),
                    ),

                    //----------------------------------สร้างบัญชีก้าวไกล-------------------------------//
                   SizedBox(height:  SizeConfig.screenHeight * 0.10,),
                    Column(
                      children: <Widget>[
                        _Buttion('สร้างบัญชีก้าวไกล', null, MColors.primaryBlue),
                        SizedBox(height: 5,),
                        _Buttion('เข้าสู่ระบบ', Login(), MColors.primaryColor),
                      ],
                    ),

                    //-------------------------------------------------------------------------------//
                   
                    Center(
                        child: TextButton(
                      child: Text("Skip for new",
                          style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        print("กด");
                      },
                    ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _Buttion(String text, Widget widget, Color colors) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                text,
                style: TextStyle(
                  // body2 -> body1
                  fontFamily: AppTheme.FontAnakotmaiLight,
                  fontSize: AppTheme.BodyTextSize,
                  color: MColors.primaryWhite,
                ),
              ),
              textColor: Colors.white,
              color: colors,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => widget),
                );
                print("กด");
                print("กด");
              },
            ),
          )
        ],
      ),
    );
  }
}
