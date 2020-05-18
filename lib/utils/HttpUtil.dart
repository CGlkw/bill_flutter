import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class HttpUtil {

  static String host = 'http://150.109.45.166:8099';

  static String test = 'http://localhost:8080';


  static Future<Response> post(String url, Map<String, dynamic> map) async {
    Dio dio =  Dio();

    Map<String, dynamic> d = new Map();
    d.addAll({
      '_app_version':'9.9.9',
      '_device_id':'c7c580f20a8896cc',
      '_device_type':'MI8',
      '_device_version':10,
      '_sdk_version':29,
    });
    d.addAll(map);
    String sign = "";
    d.forEach((key, value) {
      sign += '&$key=$value';
    });
    sign = sign.substring(1);
    d['sig'] = generateMd5(sign + 'maomi_pass_xyz');

    return await dio.post(host + url,data: d, options: new Options(contentType:"application/x-www-form-urlencoded",headers:{'Origin':'http://150.109.45.166:8099','Referer':'http://150.109.45.166:8099'}));
  }

  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
}