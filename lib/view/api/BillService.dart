import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:bill/view/api/module/Bill.dart';

// 读取 assets 文件夹中的 person.json 文件
Future<String> _loadPersonJson() async {
  return await rootBundle.loadString('json/bill.json');
}

// 将 json 字符串解析为 Person 对象
Future<List<Bill>> decodeBill() async {
  // 获取本地的 json 字符串
  String personJson = await _loadPersonJson();

  // 解析 json 字符串，返回的是 Map<String, dynamic> 类型
  final jsonList = json.decode(personJson) as List;

  return jsonList.map((e) => Bill.fromJson(e)).toList();

}

class BillService{
  final int pageSize = 10;

  Future<List<Bill>> getBillList({page:1}) async {
    List<Bill> bills= await decodeBill();
    
    int start = (page - 1 ) * pageSize;
    int end = page * pageSize;

    start = start >= (bills.length - 1) ? bills.length : start;
    end = end >= (bills.length - 1) ? bills.length : end;
    return bills.sublist(start , end);
  }

}