

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
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget{

  final String uId;

  UserInfo(this.uId);

  @override
  State<StatefulWidget> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  int _page = 0;
  List<UserVideoList> _VedioList = [];
  MomiUser _userInfo;
// 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();
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
      body:RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            KSliverAppBar(
                pinned: true,
                maxHeight: 300,
                maxAvatarSize: 120,
                image: _userInfo==null?null:CachedNetworkImageProvider(
                  _VedioList[0].mv_img_url,
                ),
                avatar: StringUtils.isEmpty(_userInfo?.mu_avatar)?
                AssetImage("assets/imgs/default_avatar.png"):
                CachedNetworkImageProvider(_userInfo?.mu_avatar),
                text:Text(_userInfo?.mu_name==null?"":_userInfo?.mu_name,style: TextStyle(fontSize: 30,color: Colors.white70),)
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 5,
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0 / 0.618,
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return _buildItemGrid2(index);
                },
                childCount: _VedioList.length,
              ),
            ),
            SliverToBoxAdapter(
              child: _page == 0 ? null : Container(
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
              ),
            ),
          ],
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

  // 刷新
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {
        _page = 1;
      });
      return true;
    });
  }

}
