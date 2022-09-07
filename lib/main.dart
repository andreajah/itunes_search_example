import 'package:flutter/material.dart';
import 'package:audio_player/components/custom_list_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_player/model/music.dart';

import 'API_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {

  // static List<Music> musicList = [Music("Tech House",
  //     "Alejandro",
  //     "https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-130.mp3",
  //     "https://picsum.photos/250?image=9")];

  String currentTitle = "";
  String currentCover = "";
  String currentSinger = "";
  IconData btnIcon = Icons.play_arrow;

  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  Duration duration = new Duration();
  Duration position = new Duration();

  void playMusic(String url) async {
    if(isPlaying && currentSong != url){
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if(result == 1){
        setState(() {
          currentSong = url;
        });
      }else if(!isPlaying){
        int result = await audioPlayer.play(url);
        if(result == 1){
          setState(() {
            isPlaying = true;
            btnIcon = Icons.play_arrow;
          });
        }
      }
    }
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  void updateList(String value){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Music>>(
        future: FetchMusic().getMusicList(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView(
              children: [
                ...snapshot.data!.map((e) => ListTile(
                  title: Text(e.results![0].trackName.toString()),
                  subtitle: Text(e.results![0].artistName.toString()),
                  trailing: CircleAvatar(
                    backgroundImage: NetworkImage(e.results![0].artworkUrl100.toString()),
                  ),
                ))
              ],
            );
          }else if(snapshot.hasError){
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text("Search for music",
      //     style: TextStyle(
      //         color: Colors.black,
      //         fontSize: 22.0,
      //         fontWeight: FontWeight.bold
      //       ),
      //     ),
      //     SizedBox(
      //       height: 20.0,
      //     ),
      //     TextField(
      //       decoration: InputDecoration(
      //         filled: true,
      //         fillColor: Colors.amber,
      //         border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(8),
      //           borderSide: BorderSide.none
      //         ),
      //         hintText: "eg: Tech House",
      //         suffixIcon: Icon(Icons.search),
      //       ),
      //     ),
      //
      //     Expanded(child: ListView.builder(
      //         itemCount: musicList.length,
      //         itemBuilder: (context, index) =>customListTile(
      //             onTap: () {
      //               playMusic(musicList[index].url.toString());
      //               setState(() {
      //                 currentTitle = musicList[index].title.toString();
      //                 currentCover = musicList[index].coverUrl.toString();
      //                 currentSinger = musicList[index].singer.toString();
      //               });
      //             },
      //             title: musicList[index].title.toString(),
      //             singer: musicList[index].singer.toString(),
      //             cover: musicList[index].coverUrl.toString()
      //         )),
      //     ),
      //     Container(
      //       decoration: BoxDecoration(
      //           color: Colors.white,
      //           boxShadow: [
      //             BoxShadow(
      //                 color: Color(0x55212121),
      //                 blurRadius: 9.0
      //             )
      //           ]),
      //       child: Column(
      //         children: [
      //           Slider.adaptive(value: position.inSeconds.toDouble(),
      //               min: 0.0,
      //               max: duration.inSeconds.toDouble(),
      //               onChanged: (value) {}),
      //           Padding(
      //             padding: const EdgeInsets.only(bottom: 8.0, left: 12.0, right: 12.0),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 Container(
      //                   height: 60.0,
      //                   width: 60.0,
      //                   decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(6.0),
      //                       image: DecorationImage(
      //                           image: NetworkImage(currentCover)
      //                       )
      //                   ),
      //                 ),
      //                 SizedBox(width: 10.0),
      //                 Expanded(
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(currentTitle, style: TextStyle(
      //                         fontSize: 16.0,
      //                         fontWeight: FontWeight.w600,
      //                       ),
      //                       ),
      //                       SizedBox(height: 5.0,),
      //                       Text(currentSinger, style: TextStyle(color: Colors.grey, fontSize: 14.0)
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 IconButton(
      //                   iconSize: 42.0,
      //                   icon: Icon(btnIcon),
      //                   onPressed: () {
      //                     if(isPlaying){
      //                       audioPlayer.pause();
      //                       setState(() {
      //                         btnIcon = Icons.pause;
      //                         isPlaying = false;
      //                       });
      //                     }else{
      //                       audioPlayer.resume();
      //                       setState(() {
      //                         btnIcon = Icons.play_arrow;
      //                         isPlaying = true;
      //                       });
      //                     }
      //                   },
      //                 )
      //               ],),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("My Playlist",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
    );
  }
}
