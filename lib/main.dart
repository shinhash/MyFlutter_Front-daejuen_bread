import 'dart:async';

import 'package:daejuen_bread/const/naver_map_const.dart';
import 'package:daejuen_bread/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  await _naverMapInitialize();
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}


Future<void> _naverMapInitialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: clientId,
    onAuthFailed: (exception) {
      print('********** naver map auth error : ${exception} **********');
    },
  );
}