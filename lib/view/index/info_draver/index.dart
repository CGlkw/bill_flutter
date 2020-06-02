import 'package:bill/view/comment/index.dart';
import 'package:bill/view/maomi/player/playui.dart';
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
                        leading: const Icon(Icons.settings),
                        title: const Text('Manage accounts'),
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
                        title: Text('Comment'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CommentPage())),
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