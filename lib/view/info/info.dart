// import 'package:flutter/material.dart';
// import 'package:get_version/get_version.dart';

// class Infoview extends StatefulWidget {
//   Infoview({Key key}) : super(key: key);

//   @override
//   _InfoviewState createState() => _InfoviewState();
// }

// class _InfoviewState extends State<Infoview> {
//   @override
//   void initState() {
//      Future.delayed(Duration.zero, () async {
//        String projectVersion;
// // Platform messages may fail, so we use a try/catch PlatformException.
// try {
//   projectVersion = await GetVersion.projectVersion;
// } on PlatformException {
//   projectVersion = 'Failed to get project version.';
// }

//       print('''
//          packageInfo! 
//          appName: $appName
//         packageName: $packageName
//          version: $version
//          buildNumber: $buildNumber
//          ''');
//     });


   
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }