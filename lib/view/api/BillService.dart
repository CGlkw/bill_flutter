import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:bill/view/api/module/Bill.dart';

List<Bill> billDate;


// 读取 assets 文件夹中的 person.json 文件
Future<String> _loadPersonJson() async {
  return await rootBundle.loadString('json/bill.json');
}

// 将 json 字符串解析为 Person 对象
Future<List<Bill>> decodeBill() async {
  if(billDate != null){
    return billDate;
  }

  // 获取本地的 json 字符串
  String personJson = await _loadPersonJson();

  // 解析 json 字符串，返回的是 Map<String, dynamic> 类型
  final jsonList = json.decode(personJson) as List;
  billDate = jsonList.map((e) => Bill.fromJson(e)).toList();
  return billDate;

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

  Future<List<List<String>>> getBillDate() async {
    List<Bill> bills= await decodeBill();
    
  }

  Future<List<Bill>> getBillByDate(DateTime startTime, DateTime endTime) async {
    assert(startTime == null);
    assert(endTime == null);

    List<Bill> bills= await decodeBill();
    return bills.where((e) => e.time.isBefore(startTime) && !e.time.isBefore(endTime)).toList();
  }
}