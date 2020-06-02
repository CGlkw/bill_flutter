
import 'package:bill/models/OscProjectCommentRefer.dart';
import 'package:bill/view/comment/CommentReferWidget.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CommentPageState();

}

class _CommentPageState extends State<CommentPage>{

  List<OscProjectCommentRefer> ref =[OscProjectCommentRefer('111','hahaah','2019-02-02'),
  OscProjectCommentRefer('222','hahaah','2019-02-03'),
  OscProjectCommentRefer('333','hahaah','2019-02-04'),
  OscProjectCommentRefer('444','hahaah','2019-02-05'),
  OscProjectCommentRefer('555','hahaah','2019-02-06')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment')
      ),
      body:CommentReferWidget(refers:ref)
    );



  }

}