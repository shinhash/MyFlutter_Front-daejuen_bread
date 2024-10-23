import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:daejuen_bread/const/naver_map_const.dart';
import 'package:logger/logger.dart';

final myLocation = NLatLng(myLocLat, myLocLng);
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
    final areaBreadList = arguments['areaBreadList'];

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
              target: myLocation,
              zoom: 14,
            ),
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: false,
          ),
          onMapReady: (NaverMapController controller) async {
            Set<NMarker> breadMakerSet = {};

            /// create to makerSet
            for (Map<String, dynamic> breadStore in areaBreadList) {
              int id = int.parse(breadStore['STORE_ID'].toString());
              double lat = double.parse(breadStore['LAT'].toString());
              double lng = double.parse(breadStore['LNG'].toString());

              final locInfo = NLatLng(lat, lng);
              final maker = NMarker(id: id.toString(), position: locInfo);
              breadMakerSet.add(maker);
            }

            /// map controller insert to makerSet
            controller.addOverlayAll(breadMakerSet);

            /// makerSet setting to makerWindow
            for(Map<String, dynamic> breadStore in areaBreadList){
              breadMakerSet.forEach((maker){
                if(maker.info.id == breadStore['STORE_ID'].toString()){
                  final onMakerInfoWindow = NInfoWindow.onMarker(
                    id: maker.info.id,
                    text: breadStore['COMPONY_NM'].toString(),
                  );
                  maker.openInfoWindow(onMakerInfoWindow);
                }
              });
            }
            naverMapController.complete(controller);
            logger.d('onMapReady');
          },
        ),
      ),
    );
  }
}
