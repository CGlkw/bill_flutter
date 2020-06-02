import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class HttpUtil {

  static String HOST_HTTP = "http://";
  static String HOST_PORT = ":8099";

  static String host = 'http://150.109.45.166:8099';

  static String test = 'http://localhost:8080';

  static String m_httpdns_url = "http://119.29.29.29/d?dn=";

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
    String ip = await getAddress();
    return await dio.post(HOST_HTTP + ip + HOST_PORT + url,data: d, options: new Options(contentType:"application/x-www-form-urlencoded"));
  }

  static Future<String> getAddress() async {
    Dio dio =  Dio();
    Response response = await dio.get(m_httpdns_url + 'api.kkmmapi.com');
    List<String> ips = response.data.toString().split(";");
    return ips[Random().nextInt(ips.length)];
  } 

  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
}