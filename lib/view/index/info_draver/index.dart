import 'package:bill/view/comment/index.dart';
import 'package:bill/view/maomi/player/playui.dart';
import 'package:bill/view/mian/charts/TestEcharts.dart';
import 'package:bill/view/slivers/SliversPage.dart';
import 'package:bill/view/slivers/TestPage.dart';
import 'package:bill/view/staggeredGridView/index.dart';
import 'package:bill/view/yyets/ui/pages/MainPage.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Stack(
          children: <Widget>[
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Add account'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.video_call),
                        title: Text('r人人影视'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Text('theme'),
                        onTap: () => Navigator.pushNamed(context, "themes"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Text('theme'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Player("1111"))),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Text('comment'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CommentPage())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Text('Staggered'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Staggered())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Text('SliversPage'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SliversPage())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Text('PullToRefreshDemo'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoadMoreDemo())),
                      ),

                    ],
                  ),
                ),
              ],
            ),
            Positioned(
             right: 5,
             top: 5,
             child: IconButton(
              icon: Icon(Icons.favorite, color: Theme.of(context).primaryColor,),
              
              onPressed: () => Navigator.pushNamed(context, "maomi"),
            ) 
           ),
          ]
        )
      ),
    );
  }

   Widget _buildHeader(context) {
    return GestureDetector(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: 40, bottom: 20),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipOval(
                // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                child: Image.asset(
                        "assets/imgs/default_avatar.png",
                        width: 80,
                      ),
              ),
            ),
            Text(
              'CG lkw',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
                    
          ],
        ),
      ),
    );
  }
}