import 'package:bill/view/api/HostListService.dart';
import 'package:flutter/material.dart';


class Maomi extends StatefulWidget {
  @override
  GridPageState createState() => new GridPageState();
}

class GridPageState extends State<Maomi>  {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  // ScrollController _scrollController = new ScrollController();

  // int _page = 0;
  // var posts = [];

  // @override
  // void initState() {
  //   super.initState();
  //   // 首次拉取数据
  //   _getPostData(true);
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels ==
  //         _scrollController.position.maxScrollExtent) {
  //       _addMoreData();
  //       print('我监听到底部了!');
  //     }
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
  //   return RefreshIndicator(
  //     onRefresh: _refreshData,
  //     child: Container(
  //       color: Colors.grey[100],
  //       child: StaggeredGridView.countBuilder(
  //         controller: _scrollController,
  //         itemCount: posts.length,
  //         primary: false,
  //         crossAxisCount: 4,
  //         mainAxisSpacing: 4.0,
  //         crossAxisSpacing: 4.0,
  //         itemBuilder: (context, index) => TileCard(
  //               img: '${posts[index]['images'][0]}',
  //               title: '${posts[index]['title']}',
  //               author: '${posts[index]['userName']}',
  //               authorUrl: '${posts[index]['iconUrl']}',
  //               type: '${posts[index]['type']}',
  //               worksAspectRatio: posts[index]['worksAspectRatio'],
  //             ),
  //         staggeredTileBuilder: (index) => StaggeredTile.fit(2),
  //       ),
  //     ),
  //   );
  // }

 

  // // 下拉刷新数据
  // Future<Null> _refreshData() async {
  //   _page = 0;
  //   _getPostData(false);
  // }

  // // 上拉加载数据
  // Future<Null> _addMoreData() async {
  //   _page++;
  //   _getPostData(true);
  // }

  // void _getPostData(bool _beAdd) async {
    
  //   HostListService().getHostList(_page).then((value) => {
  //     setState(() {
  //       if (!_beAdd) {
  //         posts.clear();
  //         posts = value;
  //       } else {
  //         posts.addAll(value);
  //       }
  //     })
  //   });
    
  // }

  
}
