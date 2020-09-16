import 'package:bill/common/BillIcon.dart';
import 'package:bill/view/api/module/Bill.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'DateSelect.dart';

class AddKeyBord extends StatefulWidget{

  Map name;
  TextEditingController controller;
  Function onSubmit;

  AddKeyBord({
    Key key,
    @required this.name,
    @required this.controller,
    @required this.onSubmit,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddKeyBordState();

}

class AddKeyBordState extends State<AddKeyBord>{
  ///键盘上的键值名称
  static const List<String> _keyNames = ['7', '8', '9', '4', '5', '6', '1', '2', '3', '.', '0', '<-'];

  ///控件点击事件
  void _onViewClick(String keyName) {
    var currentText = widget.controller.text; //当前的文本
    if (RegExp('^\\d+\\.\\d{2}\$').hasMatch(currentText) && keyName != '<-') {
      showToast('只能输入两位小数');
      return;
    }
    if ((currentText == '' && (keyName == '.' || keyName == '<-')) ||
        (RegExp('\\.').hasMatch(currentText) && keyName == '.')) return; //{不能第一个就输入.或者<-},{不能在已经输入了.再输入}
    if (keyName == '<-') {
      //{回车键}
      if (currentText.length == 0) return;
      widget.controller.text = currentText.substring(0, currentText.length - 1);
      return;
    }
    if (currentText == '0' && (RegExp('^[1-9]\$').hasMatch(keyName))) {
      //{如果第一位是数字0，那么第二次输入的是1-9，那么就替换}
      widget.controller.text = keyName;
      return;
    }
    widget.controller.text = currentText + keyName;
  }

  ///数字展示面板
  Widget _showDigitalView() {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            child: Row(
              children: [
                Hero(
                    tag: widget.name['icon'],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Icon(BillIcons.all[widget.name['icon']],size: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ),
                Text(
                  widget.name['name'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
            padding: const EdgeInsets.only(right: 8.0),
            constraints: BoxConstraints(minWidth: 100.0),
          ),
          Expanded(
            child: TextField(
              enabled: false,
              textAlign: TextAlign.end,
              controller: widget.controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入${widget.name}',
                  hintStyle: TextStyle(color: Color(0xeaeaeaea), fontSize: 18, letterSpacing: 2.0),
                  contentPadding: const EdgeInsets.all(0.0)),
            ),
          ),
        ],
      ),
    );
  }

  ///构建显示数字键盘的视图
  Widget _showKeyboardGridView() {
    List<Widget> keyWidgets = new List();
    for (int i = 0; i < _keyNames.length; i++) {
      keyWidgets.add(
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => _onViewClick(_keyNames[i]),
            child: Container(
              width: MediaQuery.of(context).size.width / 4.0,
              height: 50,
              child: Center(
                child: i == _keyNames.length - 1
                    ? Icon(Icons.backspace,color: Theme.of(context).primaryColor,)
                    : Text(
                  _keyNames[i],
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(
                      0xff606060,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Wrap(children: keyWidgets);
  }

  ///完整输入的Float值
  void _completeInputFloatValue() {
    var currentText = widget.controller.text;
    if (currentText.endsWith('.')) //如果是小数点结尾的
      widget.controller.text += '00';
    else if (RegExp('^\\d+\\.\\d\$').hasMatch(currentText)) //如果是一位小数结尾的
      widget.controller.text += '0';
    else if (RegExp('^\\d+\$').hasMatch(currentText)) //如果是整数，则自动追加小数位
      widget.controller.text += '.00';
  }

  DateTime initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        child: Column(
          children: <Widget>[
            DateSelect(
              initialDate: initialDate,
            ),
            _showDigitalView(),
            Divider(
              height: 1.0,
            ),
            Row(
              children: [
                Expanded(
                    child:_showKeyboardGridView(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4.0,
                  height: 200,
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        child: InkWell(
                          child: Center(child: Text("C", style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor
                          ),)),
                          onTap: (){
                            widget.controller.text = '';
                          },
                        ),
                      ),
                      Expanded(
                        child:Container(
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent
                          ),
                          child: InkWell(
                            child: Center(
                              child: Text("保存", style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              ),),
                            ),
                            onTap: (){
                              var value = widget.controller.text;
                              if (value != '' && value !=null) {
                                Bill bill = new Bill();
                                bill.id = bill.hashCode;
                                bill.icon = widget.name['icon'];
                                bill.type = widget.name['name'];
                                bill.remark = widget.name['name'];
                                bill.money = double.parse(value);
                                bill.time = initialDate;
                                widget.onSubmit(bill);
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    _completeInputFloatValue();
    super.deactivate();
  }
}