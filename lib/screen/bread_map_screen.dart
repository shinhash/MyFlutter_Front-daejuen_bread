import 'dart:async';
import 'package:daejuen_bread/const/naver_map_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

final myLocation = NLatLng(myLocLat, myLocLng);

class BreadMapScreen extends StatefulWidget {
  const BreadMapScreen({super.key});

  @override
  State<BreadMapScreen> createState() => _BreadMapScreenState();
}

class _BreadMapScreenState extends State<BreadMapScreen> {
  final Completer<NaverMapController> naverMapController = Completer();

  final dropDownValueList = ['동구', '서구', '중구', '유성구', '대덕구'];
  String selectedDropDownValue = '동구';

  @override
  void initState() {
    super.initState();
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
      body: SafeArea(
        child: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: myLocation,
              zoom: 18,
            ),
            indoorEnable: true,
            locationButtonEnable: true,
            consumeSymbolTapEvents: true,
          ),
          onMapReady: (NaverMapController controller) async {
            final marker_home = NMarker(id: "loc001", position: myLocation);
            controller.addOverlayAll({marker_home});

            final onMakerInfoWindow = NInfoWindow.onMarker(id: marker_home.info.id, text: '대전 집(파라도르)');
            marker_home.openInfoWindow(onMakerInfoWindow);

            naverMapController.complete(controller);
            print('onMapReady');
          },
        ),
      ),
    );
  }
}
