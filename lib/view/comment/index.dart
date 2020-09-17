
import 'package:bill/api/CommentService.dart';
import 'package:bill/models/OscProjectCommentRefer.dart';
import 'package:bill/models/comment.dart';
import 'package:bill/utils/StringUtils.dart';
import 'package:bill/view/comment/CommentItem.dart';
import 'package:bill/view/comment/CommentReferWidget.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget{
  CommentPage();
  @override
  State<StatefulWidget> createState() => _CommentPageState();

}

class _CommentPageState extends State<CommentPage> with AutomaticKeepAliveClientMixin{

  List<Comment> _data = [];

  int _page = 1;
  // 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();

   // 加载数据
  void _loadData(int page) {
    CommentService().getCommentList().then((value) => {
      setState(() {
        _data.addAll(value) ;
      })
    });
  }

  // 下拉刷新
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(milliseconds: 300), () {
      print("正在刷新...");
      _page = 1;
      _data.clear();
      _loadData(_page);
      
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(milliseconds: 300), () {
      print("正在加载更多...");
        _page++;
        _loadData(_page);
      
    });
  }

  // 刷新
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {
      });
      return true;
    });
  }

  @override
  void initState() {
    showRefreshLoading();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment')
      ),
      body:Container(
        alignment: Alignment.center,
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _onRefresh,
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return items(context, index);
            },
            itemCount: _data.isEmpty ? 0 : _data.length+1,
            separatorBuilder: (buildContext, index) {
              return Divider(
                height: 0.5,
                color: Colors.grey,
              );
            },
          ),      
        ),
      ),
    ); 
  }

  // item控件
  Widget items(context, index) {
    if (index == _data.length) {
      return Container(
        child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RefreshProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    strokeWidth: 2.0,
                  ),

                ],
              ),
            )
        ),
      );
    }
    return CommentItem(_data[index]);
  }

  @override
  bool get wantKeepAlive => true;
}