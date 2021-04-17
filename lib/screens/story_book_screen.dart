import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/chewie_list_widget.dart';
import '../ModelsAndLists/storybook_assets_list.dart';

AudioPlayer player = new AudioPlayer();

class StoryBookScreen extends StatefulWidget {
  @override
  _StoryBookScreenState createState() => _StoryBookScreenState();
}

class _StoryBookScreenState extends State<StoryBookScreen> {
  int _pageIndex = 1;
  AudioPlayerState _playerState;
  String _storyName = storyBookList[0].name;
  int _storyPages = storyBookList[0].pages;
  List<String> _storySubtitles = storyBookList[0].subtitles;

  AudioCache cache = new AudioCache(fixedPlayer: player);

  Widget build(BuildContext context) {
    bool isScreenWide =
        MediaQuery.of(context).size.width >= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Back to Story Menu",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30.r),
        color: Colors.grey,
        child: Flex(
          direction: isScreenWide ? Axis.horizontal : Axis.vertical,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(10.r),
                child: ChewieListItem(
                  videoPlayerController: VideoPlayerController.asset(
                    videoAsset(_storyName, _pageIndex),
                  ),
                  looping: true,
                  key: UniqueKey(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.0.h),
                child: Text(
                  _storySubtitles[_pageIndex - 1],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0.sp,
                    color: Colors.orange[200],
                  ),
                  key: UniqueKey(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange[200],
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  player.onPlayerStateChanged.listen((AudioPlayerState s) {
                    _playerState = s;
                  });
                  if (_playerState == AudioPlayerState.PLAYING) {
                    cache.fixedPlayer.stop();
                  }
                  if (_pageIndex > 1) {
                    setState(() {
                      _pageIndex--;
                    });
                    print("page:" + _pageIndex.toString());
                  }
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(
                  Icons.campaign_outlined,
                  size: 35.r,
                ),
                onPressed: () async {
                  player.onPlayerStateChanged.listen((AudioPlayerState s) {
                    _playerState = s;
                  });
                  print('Player State: $_playerState');
                  if (_playerState == AudioPlayerState.PLAYING) {
                    cache.fixedPlayer.stop();
                  } else {
                    await cache.play(
                      audioAsset(_storyName, _pageIndex),
                    );
                  }
                  print('Player State: $_playerState');
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  player.onPlayerStateChanged.listen((AudioPlayerState s) {
                    _playerState = s;
                  });
                  print('Player State: $_playerState');
                  if (_playerState == AudioPlayerState.PLAYING) {
                    cache.fixedPlayer.stop();
                  }
                  if (_pageIndex < _storyPages) {
                    setState(() {
                      _pageIndex++;
                    });
                    print("page:" + _pageIndex.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<AudioPlayer> playLocalAsset(
    AudioCache cache, String name, int page) async {
  return await cache.play(
    audioAsset(name, page),
  );
}

String videoAsset(String storyName, int page) {
  return ("assets/" +
      storyName.replaceAll(' ', '') +
      "-v-" +
      page.toString() +
      ".mp4");
}

String audioAsset(String storyName, int page) {
  return (storyName.replaceAll(' ', '') + "-a-" + page.toString() + ".mp3");
}
