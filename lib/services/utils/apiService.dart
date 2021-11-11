import 'dart:convert';


import 'package:bnl_task/services/models/dashboard/dashboardModel.dart';
import 'package:bnl_task/services/models/komponen/KomponenModel.dart';
import 'package:bnl_task/services/models/login/LoginModel.dart';
import 'package:bnl_task/services/models/login/loginresult.dart';
import 'package:bnl_task/services/models/mesin/mesinModel.dart';
import 'package:bnl_task/services/models/response/responsecode.dart';
import 'package:bnl_task/services/models/site/siteModel.dart';
import 'package:bnl_task/services/models/timeline/timelineModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ? make sure api url true, change variable BaseUrl if api url has changed.
  final String BaseUrl = "http://factory.grand-elephant.co.id:9994/api/v1/";
  Client client = Client();
  ResponseCode responseCode = ResponseCode();

  /**
   * ! LOGIN
   * * note : login vaidation with api
   * TODO: responstatus api must be set for show to error/message dialog.
  */
  Future<bool> LoginApp(LoginModel data) async {
    var url = Uri.parse(BaseUrl + 'login');
    var response = await client.post(url,
        headers: {'content-type': 'application/json'}, body: loginToJson(data));
    // ++ fyi : this code below for getting login result if success.
    Map resultLogin = jsonDecode(response.body)['data'];
    var loginresult = LoginResult.fromJson(resultLogin);
    // ++ fyi : this code below for getting response and message from api response.
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    print("Body? " + response.body);
    print("Access Token? " + loginresult.toString());
    if (response.statusCode == 200) {
      // ++ fyi : for set shared preferences from LoginResult model, this shared preferences fot save access token credentials for request to api.
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('access_token', "${loginresult.access_token}");
      sp.setString('username', "${loginresult.username}");
      sp.setString('jabatan', "${loginresult.jabatan}");
      return true;
    } else {
      return false;
    }
  }

  /**
   * ! DASHBOARD
   * * note : getting dashboard value from api
   */
  Future<List<DashboardModel>?> getDashboard(String token) async {
    var url = Uri.parse(BaseUrl + 'dashboard');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    print("Data Dashbaord : " + response.body);
    if (response.statusCode == 200) {
      return dashboardFromJson(response.body);
      // return compute(parseDashboard, response.body);
    } else {
      return null;
      // throw Exception(response.statusCode);
    }
  }

  List<DashboardModel> parseDashboard(String responseBody) {
    var listSite = json.decode(responseBody)['data'] as List<dynamic>;
    print('???' + listSite.toString());
    return listSite.map((e) => DashboardModel.fromJson(e)).toList();
  }

  /**
   * ! List Data Komponen
   * * note : getting data komponen by idmesin from json
   * ++      idmesin and token required! 
   */
  Future<List<KomponenModel>?> getListKomponen(
      String token, String idmesin) async {
    // ++ reminder don't forget to sending idmesin!
    var url = Uri.parse(BaseUrl + 'komponen/' + idmesin);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    print("Data Komponen : " + response.body);
    if (response.statusCode == 200) {
      return komponenFromJson(response.body);
    } else {
      return null;
    }
  }

  /**
   * ! List Data Mesin
   * * note : getting data mesin
   * ++      idsite and token required! 
   */
  Future<List<MesinModel>?> getListMesin(String token, String idsite) async {
    // ++ reminder don't forget to sending idsite!
    var url = Uri.parse(BaseUrl + 'mesin/' + idsite);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    print("Data Mesin : " + response.body);
    if (response.statusCode == 200) {
      return mesinFromJson(response.body);
    } else {
      return null;
    }
  }

  /**
   * ! TIMELINE
   * ++ LIST SITE
   * * note : getting data site
   */
  Future<List<TimelineModel>?> getListTimeline(
      String token, String idmasalah) async {
    var url = Uri.parse(BaseUrl + 'timeline/' + idmasalah);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    print("Data Site : " + response.body);
    if (response.statusCode == 200) {
      return timelineFromJson(response.body);
    } else {
      return null;
    }
  }

  /**
   * ! SITE
  * ++ TAMBAH SITE 
  * * note : add site
  */
  Future<bool> addRumah(String token, SiteModel data) async {
    var url = Uri.parse(BaseUrl + 'site');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: siteToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  /**
  * ++ UPDATE SITE
  * * note : ubah data site
  */
  Future<bool> ubahSite(String token, String idsite, SiteModel data) async {
    var url = Uri.parse(BaseUrl + 'site/' + idsite);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: siteToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /**
  * ++ DELETE SITE
  * * note : ubah data site
  */
  Future<bool> hapusSite(String token, String idsite) async {
    var url = Uri.parse(BaseUrl + 'site/' + idsite);
    var response = await client.delete(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${token}'
    });
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ! Add Data Komponen
  Future<bool> addKomponen(String token, KomponenModel data) async {
    var url = Uri.parse(BaseUrl + 'site');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: KomponenToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
