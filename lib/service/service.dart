import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:daejuen_bread/const/naver_map_const.dart';
import 'package:http/http.dart' as http;

var logger = Logger();

class BreadApi {

  breadService({required String url, required Map sendData}) async {
    List<Map<String, dynamic>> httpResult = [];
    try{
      var uri = Uri.parse('${breadIpPort.toString()}${url.toString()}');
      Map<String, String> headers = {'Content-Type':'application/json'};
      var jsonBody = json.encode(sendData);
      var response = await http.post(uri, headers: headers, body: jsonBody);

      if(response.statusCode == 200) httpResult = List.from(jsonDecode(utf8.decode(response.bodyBytes)) as List);
    } catch(e){
      logger.e(e);
    }
    return httpResult;
  }
}