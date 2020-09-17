import 'dart:convert';

import 'package:bill/api/module/BillType.dart';
import 'package:flutter/services.dart';

List<BillType> billTypeDate;


// 读取 assets 文件夹中的 person.json 文件s
Future<String> _loadPersonJson() async {
  return await rootBundle.loadString('json_data/billType.json');
}

// 将 json 字符串解析为 Person 对象
Future<List<BillType>> decodeBill() async {
  if(billTypeDate != null){
    return billTypeDate;
  }

  // 获取本地的 json 字符串
  String personJson = await _loadPersonJson();

  // 解析 json 字符串，返回的是 Map<String, dynamic> 类型
  final jsonList = json.decode(personJson) as List;
  billTypeDate = jsonList.map((e) => BillType.fromJson(e)).toList();
  return billTypeDate;

}

class BillTypeService{
  Future<List<BillType>> queryAll() async {
    List<BillType> billTypeDate = await decodeBill();
    return billTypeDate;
  }

  Future<List<BillType>> querySelected() async {
    List<BillType> billTypeDate = await decodeBill();
    return billTypeDate.where((element) => element.isSelect).toList();
  }

  Future<bool> unSelect(num id) async {
    List<BillType> billTypes = await decodeBill();
    billTypes.firstWhere((element) => element.id ==id).isSelect = false;
    billTypeDate = billTypes;
    return true;
  }

  Future<bool> selectAll(List ids) async {
    List<BillType> billTypes = await decodeBill();
    billTypes.forEach((element) {
      if(ids.contains(element.id)){
        element.isSelect = true;
      }
    });
    billTypeDate = billTypes;
    return true;
  }
}