
class Bill{
  num id;
  String type;
  String icon;
  String remark;
  DateTime time;
  num money;

  Bill({this.id, this.type, this.icon, this.remark, this.time, this.money});

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      type: json['type'],
      icon: json['icon'],
      remark: json['remark'],
      time: DateTime.parse(json['time']),
      money: double.parse(json['money'])
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'type:$type, time:$time, money:$money;\n';
  }
}

class BillChartDate{
  String name;
  DateTime startTime;
  DateTime endTime;

  BillChartDate(this.name, this.startTime, this.endTime);

  @override
  String toString() {
    return 'name:$name, startTime:$startTime, endTime:$endTime;\n';
  }
}