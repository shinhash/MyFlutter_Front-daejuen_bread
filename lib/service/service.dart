import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Service {
  Future<http.Response> getTest(String reqValue) async {

    print('this method is getTest()');
    /// android mobile localhost is 10.0.2.2
    var uri = Uri.parse('http://10.0.2.2:8088/bread/main');
    Map<String, String> headers = {'Content-Type':'application/json'};

    Map data = {
      'reqInfo': '${reqValue}',
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    print('response : ${response.body}');

    return response;
  }
}