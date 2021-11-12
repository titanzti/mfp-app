import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mfp_app/constants/colors.dart';
import 'package:mfp_app/utils/app_theme.dart';
import 'package:mfp_app/view/NavigationBar/nav_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Loginemail extends StatefulWidget {
  Loginemail({Key key}) : super(key: key);

  @override
  _LoginemailState createState() => _LoginemailState();
}

class _LoginemailState extends State<Loginemail> {
  bool isHiddenPassword = true;
 bool _isloading = false;
 TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    var tokenvalue;
  var mytoken,  userid;
  bool iserror = false;
  String _error;
  bool _autoValidate = false;
  bool _isButtonDisabled = false;
  bool _obscureText = true;
  bool _isEnabled = true;
    Future<http.Response> singin(String email, String pass) async {
    print('singin');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var url = "https://today-api.moveforwardparty.org/api/login";
    Map data = {"username": email, "password": pass};
    final headers = {
      "mode": "EMAIL",
      "content-type": "application/json",
    };
    var body = jsonEncode(data);

    var res = await http.post(url, headers: headers, body: body);
    final jsonResponse = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if (jsonResponse['status'] == 1) {
        print(jsonResponse['message']);
        if (jsonResponse != null) {
          sharedPreferences.setString(
              "token", '${jsonResponse["data"]["token"]}');
               sharedPreferences.setString(
              "myuid", '${jsonResponse["data"]["user"]["id"]}');
                sharedPreferences.setString(
              "imageURL", '${jsonResponse["data"]["user"]["imageURL"]}');
              
          sharedPreferences?.setBool("isLoggedIn", true);
          mytoken = jsonResponse["data"]["token"];
            userid =  jsonResponse["data"]["user"]["id"];
           print("myuid$userid");

          if (mytoken != null) {
            _isloading = true;
          } else if (mytoken == null) {
            iserror = true;
          }
        
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                  builder: (BuildContext context) => NavScreen()),
              (Route<dynamic> route) => false);
          
           
        } else {
          setState(() {
            _isloading = false;
          });
        }
      }
    }
    if (res.statusCode == 400) {
      if (jsonResponse['status'] == 0) {
        print(jsonResponse['message']);
        setState(() {
          _isloading = false;

          iserror = true;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    //--------------------อีเมล----------------------//
    final TextField _txtEmail = TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'อีเมล',
        hintStyle: TextStyle(fontFamily: AppTheme.FontAnakotmaiLight,),
        contentPadding: EdgeInsets.only(left: 30, top: 8),
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
    );
    //-------------------รหัสผ่าน---------------------//
    final TextField _txtPassword = TextField(
      controller: _passController,
      decoration: InputDecoration(
       hintStyle: TextStyle(fontFamily: AppTheme.FontAnakotmaiLight,),

        hintText: 'รหัสผ่าน',
        suffixIcon: InkWell(
            onTap: _togglePasswordView,
            child: Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Icon(Icons.visibility),
            )),
        contentPadding: EdgeInsets.only(left: 30, top: 16),
        border: InputBorder.none,
      ),
      obscureText: isHiddenPassword,
      keyboardType: TextInputType.text,
      autocorrect: false,
    );

    return Container(
      color: MColors.primaryWhite,
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/1200.png'), fit: BoxFit.fill)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only( left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_sharp,
                              size: 40,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              print('กด');
                            },
                          ),
                          Spacer(),
                          Container(
                            height: 100,
                            width: 170,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image:
                                  AssetImage('images/MFP-Logo-Horizontal.png'),
                            )),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                        top: 200,
                      )),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'เข้าสู่ระบบด้วย Email',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: AppTheme.FontAnakotmaiLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //--------------------อีเมล----------------------//
                      Container(
                        height: 60,
                        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(width: 1.2, color: Colors.black12),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0))),
                        child: _txtEmail,
                      ),
                      //-------------------รหัสผ่าน---------------------//
                      Container(
                        height: 60,
                        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(width: 1.2, color: Colors.black12),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0))),
                        child: _txtPassword,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 15,
                      )),
                      //----------------ปุ่ม ลืมรหัสผ่านใช่ไหม ?--------------//
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 220),
                          ),
                          TextButton(
                            child: Text('ลืมรหัสผ่าน ?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    fontFamily: AppTheme.FontAnakotmaiLight,)),
                            onPressed: () {
                              print('กด');
                            },
                          ),
                        ],
                      ),
                      //-------------------------------------------------------------------------------//
                      Padding(
                          padding: EdgeInsets.only(
                        top: 15,
                      )),
                      //-------------------------------------เข้าสู่ระบบ----------------------------------//
                        _isloading == true
                ? Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.red)),
                                onPressed: () {  },
                                child: CupertinoActivityIndicator(),
                              ),
                            )
                          ],
                        ),
                      )
                :  Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.red)),
                                child: Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(fontSize: 20,fontFamily: AppTheme.FontAnakotmaiLight,),
                                ),
                                textColor: Colors.white,
                                color: MColors.primaryColor,
                                onPressed: ()async {
                                     print('กด');
                        setState(() {
                          _isloading = true;
                        });
                        await singin(
                            _emailController.text, _passController.text);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      //-------------------------------------------------------------------------------//
                      Padding(
                          padding: EdgeInsets.only(
                        top: 15,
                      )),
                      //-----------------------------------สมัครสมาชิก----------------------------------//
                      Center(
                        child: TextButton(
                          child: Text('สมัครสมาชิก',
                              style: TextStyle(
                                  color: MColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: AppTheme.FontAnakotmaiLight,)),
                          onPressed: () {
                            print('กด');
                          },
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 5,
                      )),
                      Center(
                        child: Text(
                          '© 2021 พรรคก้าวไกล. ALL RIGHTS RESERVED.',
                          style: TextStyle(color: Colors.white,fontFamily: AppTheme.FontAnakotmaiLight,),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        bottom: 25,
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  void _togglePasswordView() {
    if (isHiddenPassword == true) {
      isHiddenPassword = false;
    } else {
      isHiddenPassword = true;
    }
    setState(() {});
  }
}
