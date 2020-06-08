

import 'dart:ui';

import 'package:bill/common/KSliverAppBar.dart';
import 'package:bill/models/momiUser.dart';
import 'package:bill/models/userVideoList.dart';
import 'package:bill/models/vedioList.dart';
import 'package:bill/utils/StringUtils.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:bill/view/api/module/Bill.dart';
import 'package:bill/view/maomi/player/playui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class NewUserInfo extends StatefulWidget{

  final String uId;
  final Key tabKey;
  NewUserInfo(this.uId,this.tabKey);

  @override
  State<StatefulWidget> createState() => _NewUserInfoState();
}

class _NewUserInfoState extends State<NewUserInfo>
    with AutomaticKeepAliveClientMixin{
  int _page = 0;
  List<UserVideoList> _VedioList = [];
  MomiUser _userInfo;
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black54,
      body: NestedScrollViewInnerScrollPositionKeyWidget(widget.tabKey,
        EasyRefresh(
          //firstRefresh: true,
          controller: _controller,
          header: MaterialHeader(),
          footer: MaterialFooter(),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0 / 0.618,
              ),
              itemBuilder: (BuildContext context, int index) {
                return _buildItemGrid2(index);
              },
            itemCount: _VedioList.length,
          ),
          onRefresh: () => _onRefresh(),
          onLoad: () => _loadMoreData(),
        ),
      ),
    );
  }

  Widget _buildItemGrid2(index){
    return Container(
      padding: EdgeInsets.all(5),
      child:InkWell(
        onTap: () =>{
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Player(_VedioList[index].mv_id)))
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius:BorderRadius.all(Radius.circular(5)),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          _VedioList[index].mv_img_url
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(child: Text(" ")),
                ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 20,
                        sigmaY: 20,
                      ),
                      child: Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black26
                        ),
                        child: Center(
                          child: Text(_VedioList[index].mv_title,style: TextStyle(color: Colors.white70),),
                        ),
                      )
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 加载数据
  void _loadData(int page) {
    HostListService().getUserInfo(widget.uId, _page).then((value) => {
      setState((){
        print(value);
        this._userInfo = value;
        this._VedioList.addAll(value.video_list);
      })
    });
  }

  // 下拉刷新
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(milliseconds: 300), () {
      print("正在刷新...");
      _page = 1;
      _VedioList.clear();
      _loadData(_page);
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(milliseconds: 2000), () {
      print("正在加载更多...");
      _page++;
      _loadData(_page);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
