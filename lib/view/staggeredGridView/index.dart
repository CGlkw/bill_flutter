import 'dart:math';

import 'package:bill/models/index.dart';
import 'package:bill/models/vedioList.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Staggered extends StatefulWidget {
  @override
  GridPageState createState() => new GridPageState();
}

class GridPageState extends State<Staggered>  {
  List<Color> colors = [Colors.deepOrange,
  Color.fromARGB(255, 113, 175, 164),
  Color.fromARGB(255, 170, 138, 87),
  Color.fromARGB(255, 89, 61, 67),
  Color.fromARGB(255, 178, 190, 126),
  Color.fromARGB(255, 227, 160, 93),];

  ScrollController _scrollController = new ScrollController();

  int _page = 1;
  List<VedioList> posts = [];

  @override
  void initState() {
    super.initState();
    // 首次拉取数据
    _getPostData(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _addMoreData();
        print('我监听到底部了!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    print(ScreenUtil.screenWidth);
    return Scaffold(
        appBar: AppBar(
            title: Text('Bill Add')
        ),
        body:Container(
          color: Colors.grey[100],
          child:RefreshIndicator(
            onRefresh: _refreshData,
            child: StaggeredGridView.countBuilder(
              controller: _scrollController,
              itemCount: posts.length,
              primary: false,
              crossAxisCount: 4,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    print("haha");
                  },
                  child:Container(
                    color: colors[Random().nextInt(colors.length)],
                    child: Image.network(
                      '${posts[index].mv_img_url}',
                      width:ScreenUtil.screenWidthDp / 2 - 4,
                      height: double.parse(posts[index].mv_play_height) * ((ScreenUtil.screenWidthDp / 2 - 4) / double.parse(posts[index].mv_play_width)),
                    ),
                  )
              ),
              staggeredTileBuilder: (index) => StaggeredTile.fit(2),

            ),
          ),

        )
    );
  }



  // 下拉刷新数据
  Future<Null> _refreshData() async {
    _page = 0;
    _getPostData(false);
  }

  // 上拉加载数据
  Future<Null> _addMoreData() async {
    _page++;
    print('111111');
    _getPostData(true);
  }

  void _getPostData(bool _beAdd) async {
    setState(() {
      if (!_beAdd) {
        posts.clear();

        for(int i = 0; i< 10; i++){
          posts.add(new VedioList()
              ..mv_img_url = "https://pic1.zhimg.com/v2-664e58f90e12b9263d6c29a7cd8eb202_1200x500.jpg"
              ..mv_play_width = "499"
              ..mv_play_height = "288");
        }
      } else {
        List<VedioList> tmp = [];
        for(int i = 0; i< 10; i++){
          tmp.add(new VedioList()
            ..mv_img_url = "https://pic1.zhimg.com/v2-664e58f90e12b9263d6c29a7cd8eb202_1200x500.jpg"
            ..mv_play_width = "499"
            ..mv_play_height = "288");
        }
        posts.addAll(tmp);
      }
    });
  }


}
