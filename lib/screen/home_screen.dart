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

  /// bread region info
  late final Map<String, dynamic> breadRegionInfo;
  late final List<Map<String, dynamic>> breadRegionList;
  List<String> breadRegionItems = [];
  String breadRegionCd = '';
  String breadRegionNm = '';

  /// bread area info
  late final Map<String, dynamic> breadAreaInfo;
  late final List<Map<String, dynamic>> breadAreaList;
  List<String> breadAreaItems = [];
  String breadAreaCd = '';
  String breadAreaNm = '';

  @override
  void initState() {
    super.initState();
    regionAreaInitialize();
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
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('도시 '),
              DropdownButton(
                value: breadRegionNm,
                items: breadRegionItems.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                onChanged: (value) {
                  setState(() {
                    dropDownItemChange(dropDownMenu: 'region', value: value.toString());
                  });
                },
              ),


              const Text('지역 '),
              DropdownButton(
                value: breadAreaNm,
                items: breadAreaItems.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                onChanged: (value) {
                  setState(() {
                    dropDownItemChange(dropDownMenu: 'area', value: value.toString());
                  });
                },
              ),
            ],
          ),


          Expanded(
            child: Center(
              child: Image.asset(
                'asset/img/breads_store.jpg',
              ),
            ),
          ),

          if(breadAreaCd != '')
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
                Map sendData = {'regionCd': breadRegionCd, 'areaCd': breadAreaCd};
                final breadAreaStoreInfo = await BreadApi().breadService(url: '/bread/store/list', sendData: sendData);

                final breadAreaInfo = List<Map<String, dynamic>>.from(breadAreaStoreInfo['breadAreaInfo']);
                final breadStoreInfo = List<Map<String, dynamic>>.from(breadAreaStoreInfo['breadStoreInfo']);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const BreadMapScreen();
                    },
                    settings: RouteSettings(
                      arguments: {
                        'breadAreaInfo': breadAreaInfo,
                        'breadStoreInfo': breadStoreInfo,
                      },
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

  /// 도시,지역 조회
  regionAreaInitialize() async {
    breadRegionInfo = await BreadApi().breadService(url: '/bread/region/list', sendData: {});
    breadAreaInfo = await BreadApi().breadService(url: '/bread/area/list', sendData: {});

    breadRegionList = new List<Map<String, dynamic>>.from(breadRegionInfo['breadRegionInfo']);
    breadAreaList = new List<Map<String, dynamic>>.from(breadAreaInfo['breadAreaInfo']);
    setState(() {
      dropDownItemChange(dropDownMenu: 'region', value: '');
    });
  }

  /// region, area info change function
  dropDownItemChange({required String dropDownMenu, required String value}){
    switch(dropDownMenu){
      case 'region':
        if(breadRegionItems.isEmpty){
          for(Map mapInfo in breadRegionList){
            if(breadRegionItems.isEmpty){
              breadRegionCd = mapInfo['REGION_CD'];
              breadRegionNm = mapInfo['REGION_NM'];
            }
            breadRegionItems.add(mapInfo['REGION_NM']);
          }
        }else{
          for(Map mapInfo in breadRegionList) {
            if(value == mapInfo['REGION_NM']) {
              breadRegionCd = mapInfo['REGION_CD'];
              breadRegionNm = mapInfo['REGION_NM'];
            }
          }
        }

        breadAreaItems = [];
        for(Map mapInfo in breadAreaList){
          if(mapInfo['REGION_CD'] == breadRegionCd){
            if(breadAreaItems.isEmpty){
              breadAreaCd = mapInfo['AREA_CD'];
              breadAreaNm = mapInfo['AREA_NM'];
            }
            breadAreaItems.add(mapInfo['AREA_NM']);
          }
        }
        if(breadAreaItems.isEmpty){
          breadAreaCd = '';
          breadAreaNm = '-- 선택 --';
          breadAreaItems.add('-- 선택 --');
        }
        break;
      case 'area':
        for(Map mapInfo in breadAreaList){
          if(value == mapInfo['AREA_NM']){
            breadAreaCd = mapInfo['AREA_CD'];
            breadAreaNm = mapInfo['AREA_NM'];
          }
        }
        break;
    }
  }
}
