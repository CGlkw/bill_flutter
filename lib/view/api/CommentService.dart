import 'dart:convert';

import 'package:bill/models/comment.dart';
import 'package:flutter/services.dart';

List<Comment> comments ;

// 读取 assets 文件夹中的 person.json 文件s
Future<String> _loadPersonJson() async {
  return await rootBundle.loadString('json_data/comment.json');
}

// 将 json 字符串解析为 Person 对象
Future<List<Comment>> decodeComment() async {
  if(comments != null){
    return comments;
  }
  comments = [];
  // 获取本地的 json 字符串
  String personJson = await _loadPersonJson();
  
  // 解析 json 字符串，返回的是 Map<String, dynamic> 类型
  final jsonList = json.decode(personJson) as List;
  jsonList.forEach((element) {
    List reply = element["reply"] as List;
    Comment re = Comment.fromJson(element);
    if(reply != null && reply.length > 0){
      re.reply = reply.map((e) =>  Comment.fromJson(e)).toList();
    }
    comments.add(re);
  });
  return comments;

}

class CommentService {
  Future<List<Comment>> getCommentList() async {
    return decodeComment();
  }
}