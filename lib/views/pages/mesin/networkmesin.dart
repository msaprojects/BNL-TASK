import 'dart:convert';

import 'package:bnl_task/services/models/mesin/mesinModel.dart';
import 'package:bnl_task/services/utils/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;
List<MesinModel> parseSite(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  print(listSite);
  return listSite.map((e) => MesinModel.fromJson(e)).toList();
}

Future<List<MesinModel>> fetchMesin(String token, String idsite) async {
  var url = Uri.parse(_apiService + 'mesin/' + idsite);
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  print("NETWORK MESIN? " + token);
  if (response.statusCode == 200) {
    print('Success?');
    return compute(parseSite, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}
