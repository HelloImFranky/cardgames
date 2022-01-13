import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:validators/sanitizers.dart';

class DeckAPIProvider {
  String baseURL = 'http://deckofcardsapi.com/api';

  Uri _url(String path, [Map<String, dynamic> params = const {}]) {
    String queryString = "";
    if (params.isNotEmpty) {
      queryString = "?";
      params.forEach(
        (key, value) {
          queryString += "$key=${value.toString()}&";
        },
      );
    }

    path = rtrim(path, '/');
    path = ltrim(path, '/');
    queryString = rtrim(queryString, '&');

    final url = '$baseURL/$path/$queryString';
    return Uri.parse(url);
  }

  Future<Map<String, dynamic>> httpGet(
    String path, {
    Map<String, dynamic> params = const {},
  }) async {
    final url = _url(path, params);
    final response = await http.get(url);
    if (response.bodyBytes.isEmpty) {
      throw Exception("failed to get *(deckapiprovider)*");
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // Future<Map<String, dynamic>> get(String url) async {
  //   var responseJson;
  //   try {
  //     final response = await http.get(Uri.parse(baseURL + url));
  //     //take the deckID from the Json incoming from the url response
  //     deckId = response.body.split(',')[1].split(':').last;
  //     //check status code
  //     responseJson = _response(response);
  //   } on SocketException {
  //     throw Exception('No internet Connection');
  //   }
  //   return responseJson;
  // }
  //
  // dynamic _response(http.Response response) {
  //   switch (response.statusCode) {
  //     case 200:
  //       var responseJson = json.decode(response.body.toString());
  //       return responseJson;
  //     case 400:
  //       throw Exception(response.body.toString());
  //     default:
  //       throw Exception(
  //           'Error occured while communication with server: ${response.statusCode}');
  //   }
  // }
}
