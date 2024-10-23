import 'package:daejuen_bread/screen/bread_map_screen.dart';
import 'package:daejuen_bread/service/service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final affLocNmList = ['동구', '서구', '중구', '유성구', '대덕구'];
  String affLocNm = '동구';
  late final breadRegionList;
  late String breadRegionCd;
  late final breadAreaList;

  @override
  void initState() {
    super.initState();
    initBreadRegion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대전 빵지순례'),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'asset/img/breads_store.jpg',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('시 : '),
              // FutureBuilder(
              //   future: initBreadRegion(),
              //   builder: (context, snapshot){
              //     return DropdownButton(
              //       value: breadRegionCd,
              //       items: breadRegionList
              //           .map((item) => DropdownMenuItem(
              //           value: item['REGION_CD'],
              //           child: Text(item['REGION_NM'])))
              //           .toList(),
              //       onChanged: (value) {
              //         setState(() {
              //           breadRegionCd = value.toString();
              //         });
              //       },
              //     );
              //   },
              // ),
              Text('구 : '),
              DropdownButton(
                value: affLocNm,
                items: affLocNmList.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                onChanged: (value) {
                  setState(() {
                    affLocNm = value.toString();
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              child: const Text('빵집 찾기'),
              onPressed: () async {
                /// spring boot bread api connection
                Map sendData = {'areaCd': 'DA001'};
                final httpResult = await BreadApi()
                    .breadService(url: '/bread/store/list', sendData: sendData);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const BreadMapScreen();
                    },
                    settings: RouteSettings(
                      arguments: {'areaBreadList': httpResult},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  initBreadRegion() async {
    breadRegionCd = '';

    final httpResult =
        await BreadApi().breadService(url: '/bread/region/list', sendData: {});
    breadRegionList = httpResult;
    print('breadRegionList : ${breadRegionList}');
  }
}
