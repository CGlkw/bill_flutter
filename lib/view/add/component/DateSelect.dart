
import 'package:bill/utils/DateUtils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelect extends StatefulWidget{

  DateTime initialDate;

  DateTime firstDate;

  DateTime lastDate;

  DateSelect({
    Key key,
    this.initialDate,
    this.firstDate,
    this.lastDate})
     :super(key: key){
    if (initialDate == null){
      initialDate = DateTime.now();
    }
    if (firstDate == null){
      firstDate = DateTime.parse("2000-01-01 01:00:00");
    }
    if (lastDate == null){
      lastDate = DateTime.parse("2088-01-01 01:00:00");
    }
  }

  @override
  State<StatefulWidget> createState() => DateSelectState();
}

class DateSelectState extends State<DateSelect>with AutomaticKeepAliveClientMixin{
  PageController _pageController = new PageController(initialPage: 1,
      keepPage: true,viewportFraction: 1.0);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController.addListener((){
      if( _pageController.offset <= 0 ){
        _pageController.jumpToPage(1);
      }
      if( _pageController.offset >= 2 * (MediaQuery.of(context).size.width - 100) ){
        _pageController.jumpToPage(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildContext();
  }

  Widget _buildContext(){
    var date = DateUtil.formatDate(widget.initialDate,format: "yyyy-MM-dd");
    return InkWell(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: (){
              _subDate();
              _pageController.previousPage(duration:const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
            },
          ),
          Expanded(
              child: Container(
                height: 50,
                child: PageView(
                  controller: _pageController,
                  children: [
                    Center(
                      child: Text(_lastDate()),
                    ),
                    Center(
                      child: Text(date),
                    ),
                    Center(
                      child: Text(_nextDate()),
                    )
                  ],
                )
              ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: (){
              _addDate();
              _pageController.nextPage(duration:const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
            },)
        ],
      ),
      onTap: () {
        showDatePicker(
            context: context,
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate
        ).then((value) => {
          print(value),
          _setValue(value)
        });
      },
    );
  }

  void _setValue (value){
    if(value != null){
      setState(() {
        widget.initialDate = value;
      });
    }
  }

  String _lastDate(){
     return DateUtil.formatDate(widget.initialDate.subtract(Duration(days: 1)),format: "yyyy-MM-dd");
  }

  String _nextDate(){
    return DateUtil.formatDate(widget.initialDate.add(Duration(days: 1)),format: "yyyy-MM-dd");
  }

  void _addDate(){
    setState(() {
      widget.initialDate = widget.initialDate.add(Duration(days: 1));
    });
  }

  void _subDate(){
    setState(() {
      widget.initialDate = widget.initialDate.subtract(Duration(days: 1));
    });
  }
}