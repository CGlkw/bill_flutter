import 'package:bill/models/index.dart';
import 'package:bill/models/vedioList.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'common/TileCard.dart';


class Maomi extends StatefulWidget {
  @override
  GridPageState createState() => new GridPageState();
}

class GridPageState extends State<Maomi>  {

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
              itemBuilder: (context, index) => TileCard(
                    img: posts[index].mv_img_url,
                    title: posts[index].mv_title,
                    like: posts[index].mv_like,
                    authorUrl: posts[index].mv_img_url,
                    mvId: posts[index].mv_id,
                    height: double.parse(posts[index].mv_play_height),
                    width: double.parse(posts[index].mv_play_width)
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
    
    HostListService().getHostList(_page).then((value) => {
      print(_page),
      setState(() {
        if (!_beAdd) {
          posts.clear();
          posts = value;
        } else {
          posts.addAll(value);
        }
      })
    });
    
  }

  
}
