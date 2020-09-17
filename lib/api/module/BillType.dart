
class BillType{
  num id;
  String type;
  String icon;
  bool isSelect;
  DateTime time;

  BillType({this.id, this.type, this.icon, this.isSelect, this.time});


  factory BillType.fromJson(Map<String, dynamic> json) {
    return BillType(
        id: json['id'],
        type: json['type'],
        icon: json['icon'],
        isSelect: json['isSelect'],
        time: DateTime.parse(json['time']),
    );
  }
}