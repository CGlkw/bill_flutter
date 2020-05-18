
import 'dart:convert';

import 'package:steel_crypt/steel_crypt.dart';

class AesUtil{

  static final String key = '625202f9149maomi';

  static final String vi = '5efd3f6060emaomi';

  static final AesCrypt aesEncrypter = AesCrypt(key, 'cbc', 'pkcs7');

  static String encode(String s){
    String encrypted = aesEncrypter.encrypt(s, vi); //encrypt
    var s3 = base64.decode(encrypted);
    print(s3);
    return _bytesToHexString(s3);
  }

  static String decode(String s){
    var localInput = _hexTobytes(s);
    var s1 = base64.encode(localInput);
    return aesEncrypter.decrypt(s1, vi);
  }
  
  static List<int> _hexTobytes (String hex){
    List<int> result = [];
    for(int i = 0; i < hex.length; i+= 2){
      String s = hex.substring(i,i + 2);
      result.add(int.parse(s, radix: 16));
    }
    return result;
  }

  static String _bytesToHexString(List<int> bytes){
    String result = "";
    bytes.forEach((element) {
      var s = element.toRadixString(16).toUpperCase();
      if(s.length == 1){
        result += '0' + element.toRadixString(16).toUpperCase();
      }else if(s.length == 0){
        result += '00';
      } else {
        result += element.toRadixString(16).toUpperCase();
      }
    });
    return result;
  }
}