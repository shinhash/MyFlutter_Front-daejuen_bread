import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:daejuen_bread/const/naver_map_const.dart';
import 'package:logger/logger.dart';

dynamic areaLocation;
var logger = Logger();

class BreadMapScreen extends StatefulWidget {
  const BreadMapScreen({super.key});

  @override
  State<BreadMapScreen> createState() => _BreadMapScreenState();
}

class _BreadMapScreenState extends State<BreadMapScreen> {
  final Completer<NaverMapController> naverMapController = Completer();

  @override
  Widget build(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final breadAreaInfo = arguments['breadAreaInfo'];
    final breadStoreInfo = arguments['breadStoreInfo'];

    if((breadAreaInfo as List).isNotEmpty){
      final areaLat = double.parse(breadAreaInfo[0]['AREA_LAT']);
      final areaLng = double.parse(breadAreaInfo[0]['AREA_LNG']);
      areaLocation = NLatLng(areaLat, areaLng);
    }else{
      areaLocation = const NLatLng(defaultLocLat, defaultLocLng);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('대전 빵지순례'),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: areaLocation,
              zoom: 14,
            ),
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: false,
          ),
          onMapReady: (NaverMapController controller) async {
            naverMapController.complete(controller);
            logger.d('onMapReady');

            showMaker(
              controller: controller,
              breadStoreInfo: breadStoreInfo,
            );
          },
        ),
      ),
    );
  }

  showMaker({required NaverMapController controller, required List<Map<String, dynamic>> breadStoreInfo}){
    Set<NMarker> breadMakerSet = {};

    /// create to makerSet
    for (Map<String, dynamic> breadStore in breadStoreInfo) {
      int storeId = int.parse(breadStore['STORE_ID'].toString());
      double storeLat = double.parse(breadStore['STORE_LAT'].toString());
      double storeLng = double.parse(breadStore['STORE_LNG'].toString());

      final locInfo = NLatLng(storeLat, storeLng);
      final maker = NMarker(id: storeId.toString(), position: locInfo);
      breadMakerSet.add(maker);
    }

    /// map controller insert to makerSet
    controller.addOverlayAll(breadMakerSet);

    /// makerSet setting to makerWindow
    for(Map<String, dynamic> breadStore in breadStoreInfo){
      breadMakerSet.forEach((maker){
        if(maker.info.id == breadStore['STORE_ID'].toString()){
          final onMakerInfoWindow = NInfoWindow.onMarker(
            id: maker.info.id,
            text: breadStore['STORE_NM'].toString(),
          );
          maker.openInfoWindow(onMakerInfoWindow);
        }
      });
    }
  }

  hideMaker({required NaverMapController controller}){
    /// map controller insert to makerSet
    controller.addOverlayAll({});
  }

}
