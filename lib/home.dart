import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> videos = [
    'assets/1.mp4',
    'assets/2.mp4',
    'assets/3.mp4',
    'assets/4.mp4',
    'assets/5.mp4',
    'assets/6.mp4',
    'assets/7.mp4',
    'assets/8.mp4',
    'assets/9.mp4',
    'assets/10.mp4',
    'assets/11.mp4',
    'assets/12.mp4',
    'assets/13.mp4',
    'assets/14.mp4',
    'assets/15.mp4',
    'assets/16.mp4',
    'assets/17.mp4',
    'assets/18.mp4',
    'assets/19.mp4',
    'assets/20.mp4',
    'assets/21.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TikTok Clone'),
      ),
      body: PageView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoPlayerWidget(videoUrls: videos, currentIndex: index);
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final List<String> videoUrls;
  final int currentIndex;

  const VideoPlayerWidget({Key? key, required this.videoUrls, required this.currentIndex}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _initializeAndPlay(_currentIndex);
  }

  void _initializeAndPlay(int index) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.asset(widget.videoUrls[index])
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _videoPlayerController?.play();
        }
      });

    _videoPlayerController?.addListener(_videoListener);
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _videoListener() {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.position == _videoPlayerController!.value.duration) {
      _playNextVideo();
    }
  }

  void _playNextVideo() {
    if (_currentIndex < widget.videoUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _initializeAndPlay(_currentIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_videoPlayerController?.value.isPlaying ?? false) {
            _videoPlayerController?.pause();
          } else {
            _videoPlayerController?.play();
          }
        });
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _videoPlayerController?.value.isInitialized ?? false
            ? VideoPlayer(_videoPlayerController!)
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
