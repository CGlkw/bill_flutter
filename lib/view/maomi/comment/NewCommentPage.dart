
import 'package:bill/models/comment.dart';
import 'package:bill/view/api/CommentService.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:bill/view/maomi/comment/CommentItem.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class NewCommentPage extends StatefulWidget{
  String _mvId;
  final Key key;
  NewCommentPage(this._mvId,this.key);
  @override
  State<StatefulWidget> createState() => _NewCommentPageState();

}

class _NewCommentPageState extends State<NewCommentPage> with AutomaticKeepAliveClientMixin{

  List<Comment> _data = [];

  int _page = 1;
  // 承载listView的滚动视图

  // 加载数据
  void _loadData(int page) {
    HostListService().getComments(widget._mvId, _page).then((value) => {
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

  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollViewInnerScrollPositionKeyWidget(widget.key,
        EasyRefresh(
          //firstRefresh: true,
          controller: _controller,
          header: MaterialHeader(),
          footer: MaterialFooter(),
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            itemBuilder: (buildContext, index) {
              return items(context, index);
            },
            itemCount: _data.length,
            separatorBuilder: (buildContext, index) {
              return Divider(
                height: 0.5,
                color: Colors.grey,
              );
            },
          ),
          onRefresh: () => _onRefresh(),
          onLoad: () => _loadMoreData(),
        ),
      /*RefreshIndicator(
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
      ),*/
    );
  }

  // item控件
  Widget items(context, index) {

    return CommentItem(_data[index]);
  }

  @override
  bool get wantKeepAlive => true;
}