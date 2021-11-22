import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 100, top: 70),
                      height: 280,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('images/MFP-Logo-Verticle.png'),
                      )),
                    ),
                  ),
                  //----------------------------------สร้างบัญชีก้าวไกล-------------------------------//
                  Container(
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
                              'สร้างบัญชีก้าวไกล',
                              style: TextStyle(
                                // body2 -> body1
                                fontFamily: AppTheme.FontAnakotmaiLight,
                                fontSize: AppTheme.BodyTextSize,
                                color: MColors.primaryWhite,
                              ),
                            ),
                            textColor: Colors.white,
                            color: MColors.primaryBlue,
                            onPressed: () {
                              print("กด");
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  //-------------------------------------------------------------------------------//
                  //------------------------------------เข้าสู่ระบบ-----------------------------------//
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                // body2 -> body1
                                fontFamily: AppTheme.FontAnakotmaiLight,
                                fontSize: AppTheme.BodyTextSize,
                                color: MColors.primaryWhite,
                              ),
                            ),
                            textColor: MColors.primaryWhite,
                            color: MColors.primaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                              print("กด");
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  //-------------------------------------------------------------------------------//
                  Padding(padding: EdgeInsets.only(top: 20)),
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
        ));
  }
}
