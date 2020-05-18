import 'dart:convert';

import 'package:bill/models/vedioList.dart';
import 'package:bill/utils/AesUtil.dart';
import 'package:bill/utils/HttpUtil.dart';
import 'package:dio/dio.dart';

class HostListService{
  String uid = '71029569';
  Future<List<VedioList>> getHostList(int page) async {
    Map param = new Map()..addAll({
      'page':page,
      'perPage':'14',
      'uId':uid
    });
    var data = AesUtil.encode(param.toString());
    Response response = await HttpUtil.post('/api/videos/listHot', {'data':data});
    var result = AesUtil.decode(response.data);
    Map resultMap = json.decode(result) as Map;
    if(resultMap['code'] as num == 0 ){
      List result = resultMap['data']['list'] as List;
      return  result.map((e) => VedioList.fromJson(e)).toList();
    }

    return null;
  }

}