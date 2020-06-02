import 'package:bill/models/OscProjectCommentRefer.dart';
import 'package:flutter/material.dart';

class CommentReferWidget extends StatelessWidget {
  final List<OscProjectCommentRefer> refers;
  const CommentReferWidget({Key key, this.refers}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    int referCount = refers?.length??0;
    Widget emptyWidget = Divider(color: Colors.transparent, height: 0,);
    if(referCount > 0) {
      Widget referWidget;
      for(int index = 0; index < referCount; index++){
        referWidget = buildRefer(refers.elementAt(index), index, index==0?emptyWidget:referWidget);
      }
      return referWidget;
    } else {
      return emptyWidget;
    }
  }

  Widget buildRefer(OscProjectCommentRefer refer, int index, Widget referWidget){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical:2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          referWidget,
          buildReferContent(refer, index),
        ],
      ),
    );
  }

  Widget buildReferContent(OscProjectCommentRefer refer, int index){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(" ${index+1}  ", style: TextStyle(),),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${refer.author}", style: TextStyle(),),
                Offstage(
                  offstage: refer.pubDate != null,
                  child: Text("${refer.pubDate}", style: TextStyle(),),
                ),
                Text(refer.content, style:TextStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}