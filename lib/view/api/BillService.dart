import 'dart:convert';

import 'package:bill/utils/TimeMachineUtil.dart';
import 'package:common_utils/common_utils.dart';
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

  Future<List<List<String>>> getBillChartDate() async {
    Map<String, DateTime> minMaxTime = await getMinMaxTime();
    

  }

  Future<List<Bill>> getBillByDate(DateTime startTime, DateTime endTime) async {
    assert(startTime != null);
    assert(endTime != null);

    List<Bill> bills= await decodeBill();
    return bills.where((e) => !e.time.isBefore(startTime) && e.time.isBefore(endTime)).toList();
  }

  Future<Map<String, DateTime>> getMinMaxTime() async {
    List<Bill> bills= await decodeBill();
    DateTime minTime,maxTime;
    bills.forEach((element) {
      minTime = minTime == null ? element.time : element.time.isBefore(minTime) ? element.time : minTime;
      maxTime = maxTime == null ? element.time : element.time.isAfter(minTime) ? element.time : maxTime;
    });
    return {'minTime': minTime, 'maxTime': maxTime};
  }

  List<BillChartDate> getWeekChartDate(DateTime startTime, DateTime endTime){
    assert(startTime != null);
    DateTime now = DateTime.now();
    endTime = endTime ?? now;
    int nowW = now.weekday;
    DateTime nowWeek1 = now.add(Duration(days:-(nowW-1)));
    DateTime lastWeek1 = now.add(Duration(days:-(nowW+6)));
    print('本周周一：$nowWeek1，上周周一：$lastWeek1');
    DateTime _endTime = endTime;
    List<BillChartDate> result = new List();
    while(true){
      
      if(_endTime.isBefore(startTime)){
        break;
      }
      int weekday = _endTime.weekday;
      DateTime endWeek1 = _endTime.add(Duration(days:-(weekday-1)));

      String endWeekName;
      DateTime start, end;
      start = endWeek1;
      end = start.add(Duration(days:7));
      if(endWeek1.isAfter(nowWeek1) || endWeek1.compareTo(nowWeek1) == 0){
        endWeekName = '本周';
        
      }else if(endWeek1.isBefore(nowWeek1) && (endWeek1.isAfter(lastWeek1) || endWeek1.compareTo(lastWeek1) == 0)){
        endWeekName = '上周';
      }else{
        DateTime endWeek7 = start.add(Duration(days:6));
        int week = TimeMachineUtil.getWeeksOfYear(endWeek7);
        if(endWeek7.year != now.year){
          endWeekName = '${endWeek1.year}-$week周';
        }else{
          endWeekName = '$week周';
        }
        
      }
      
      result.add(BillChartDate(endWeekName,start,end));

      _endTime = _endTime.add(Duration(days:-(weekday+6)));
    }
    return result;
  }

  List<BillChartDate> getMonthChartDate(DateTime startTime, DateTime endTime){
    assert(startTime != null);
    DateTime now = DateTime.now();
    endTime = endTime ?? now;
    int nowM = now.month;
    DateTime nowMonth1 = DateTime(now.year,nowM,1);
    int lastMonth = nowM - 1;
    int lastMDays = MONTH_DAY[lastMonth == 0? 12 : lastMonth];
    lastMDays = DateUtil.isLeapYearByYear(now.year) && lastMonth == 2?  lastMDays+ 1: lastMDays;
    DateTime lastMonth1 = nowMonth1.add(Duration(days:-lastMDays));
    print('本月一号：$nowMonth1，上月一号：$lastMonth1');
    DateTime _endTime = endTime;
    List<BillChartDate> result = new List();
    while(true){
      
      if(DateTime(_endTime.year, _endTime.month) .isBefore(DateTime(startTime.year, startTime.month))){
        break;
      }
      int month = _endTime.month;
      DateTime endMonth1 = DateTime(_endTime.year,month,1);

      String endWeekName;
      DateTime start, end;
      start = endMonth1;
      int monthDays =  MONTH_DAY[month];
      monthDays =  DateUtil.isLeapYearByYear(endMonth1.year) && month == 2?  monthDays+ 1: monthDays;
      end = start.add(Duration(days:monthDays));
      if(endMonth1.isAfter(nowMonth1) || endMonth1.compareTo(nowMonth1) == 0){
        endWeekName = '本月';
        
      }else if(endMonth1.isBefore(nowMonth1) && (endMonth1.isAfter(lastMonth1) || endMonth1.compareTo(lastMonth1) == 0)){
        endWeekName = '上月';
      }else{
        
        if(_endTime.year != now.year){
          endWeekName = '${_endTime.year}-$month月';
        }else{
          endWeekName = '$month月';
        }
      }   
      result.add(BillChartDate(endWeekName,start,end));
      int lastEndMonth = month - 1;
      int lastEndYear = _endTime.year;
      if(lastEndMonth == 0){
        lastEndMonth = 12;
        lastEndYear -- ;
      }

      _endTime = DateTime(lastEndYear,lastEndMonth,_endTime.day);
    }
    return result;
  }

  List<BillChartDate> getYearChartDate(DateTime startTime, DateTime endTime){
    assert(startTime != null);
    DateTime now = DateTime.now();
    endTime = endTime ?? now;
    int nowYear = now.year;
    DateTime nowYear1 = DateTime(nowYear,1,1);
    print('今年一月一号：$nowYear1');
    DateTime _endTime = endTime;
    List<BillChartDate> result = new List();
    while(true){
      
      if(_endTime.year < startTime.year){
        break;
      }
      DateTime endYear1 = DateTime(_endTime.year,1,1);
      String endWeekName;
      DateTime start, end;
      start = endYear1;
      end = DateTime(_endTime.year + 1,1,1);
      if(endYear1.isAfter(nowYear1) || endYear1.compareTo(nowYear1) == 0){
        endWeekName = '今年';
      }else{        
        endWeekName = '${_endTime.year}年';
      }   
      result.add(BillChartDate(endWeekName,start,end));

      _endTime = DateTime(_endTime.year-1,_endTime.month,_endTime.day);
    }
    return result;
  }
}