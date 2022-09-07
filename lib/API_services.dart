import 'model/music.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchMusic{
  List<Music> result = [];
  String fetchurl = "https://itunes.apple.com/search?term=jack+johnson&entity=musicVideo";
  Future<List<Music>> getMusicList() async{
    var url = Uri.parse(fetchurl);
    var response = await http.get(url);
    try {
      if(response.statusCode == 200){
        Map<String, dynamic> maps = json.decode(response.body);
        result = Music.fromJson(maps) as List<Music>;
      }else{
        print('api error');
      }
    } on Exception catch (e) {
      print('error : $e');
    }
    return result;
  }
}