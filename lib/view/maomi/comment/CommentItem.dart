
import 'package:bill/models/comment.dart';
import 'package:bill/utils/StringUtils.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget{

  Comment _data;

  CommentItem(this._data);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: ListTile(
        leading:StringUtils.isEmpty(_data.mu_avatar)?Image.asset(
          "assets/imgs/default_avatar.png",
          width: 40,
        ):Container(
          height: 40.0,
          width: 40.0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              _data.mu_avatar,
            ),
          ),
        ),
        title:Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 3, 0, 2),
              child:  Text(
                '${_data.mu_name}',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white30
                ),
              ),
            ),
            Expanded(
              child: Text(''), // 中间用Expanded控件
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
              child:  Text('${_data.mc_floor}楼',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.white30
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
              child:  Text('${_data.mc_created}',
                style: TextStyle(
                    fontSize: 10,
                    color:Colors.white30
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
              child:  Text('${_data.mc_text}',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70
                ),
              ),
            ),
            _data.reply != null && _data.reply.length > 0 ? Container(
              decoration: BoxDecoration(
                color: Color(0x50eeeeee),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              padding:  EdgeInsets.fromLTRB(10, 2, 2, 2),
              margin: EdgeInsets.fromLTRB(0, 2, 0, 5),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: _data.reply.map((e) =>
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                    child:  RichText(
                      text:TextSpan(
                        children: [
                          TextSpan(
                            text: '${e.mu_name}',
                            style: TextStyle(fontSize: 12, color: Colors.blueAccent),
                          ),
                          TextSpan(
                            text: ':${e.mc_text}',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ]
                      )
                    ),
                  )
                ).toList(),
              ),
            ):Container()
          ],
        ),
      ),
    );
  }
}