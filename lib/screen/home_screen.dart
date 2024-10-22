import 'package:daejuen_bread/screen/bread_map_screen.dart';
import 'package:daejuen_bread/service/service.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대전 빵지순례'),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'asset/img/breads_store.jpg',
              ),
            ),
          ),
          TextField(
            controller: textEditController,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) {
                //       return BreadMapScreen();
                //     },
                //   ),
                // );
                print('textEditController.value : ${textEditController.value.text}');
                final result = Service().getTest(textEditController.value.text);
                print('result : ${result}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              child: Text('빵집 찾기'),
            ),
          ),
        ],
      ),
    );
  }
}
