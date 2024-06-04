import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoPlayerWidget extends StatefulWidget {
  final List<String> videoUrls;
  final int currentIndex;
  final String email;
  final VoidCallback onVideoEnd; // Callback para el final del video
  final bool isLastVideo;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrls,
    required this.currentIndex,
    required this.email,
    required this.onVideoEnd,
    required this.isLastVideo,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  late int _currentIndex;
  Timer? _timer;
  int _timeWatched = 0;

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
          _startTimer();
        }
      });

    _videoPlayerController?.addListener(_videoListener);
  }

  void _startTimer() {
    _timeWatched = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeWatched++;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _sendTimeWatched();
  }

  void _sendTimeWatched() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/video'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'correo': widget.email,
        'videoId': widget.videoUrls[_currentIndex],
        'timeWatched': _timeWatched,
      }),
    );
    if (response.statusCode == 200) {
      print('Tiempo de visualización enviado correctamente');
    } else {
      print('Error al enviar el tiempo de visualización');
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();
    _stopTimer();
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
        _stopTimer();
        _timeWatched = 0; // Reiniciar el tiempo de visualización al cambiar de video
        _currentIndex++;
        _initializeAndPlay(_currentIndex);
      });
    } else {
      _videoPlayerController?.removeListener(_videoListener);
      widget.onVideoEnd(); // Llama al callback cuando el último video termina
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_videoPlayerController?.value.isPlaying ?? false) {
            _videoPlayerController?.pause();
            _stopTimer();
          } else {
            _videoPlayerController?.play();
            _startTimer();
          }
        });
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _videoPlayerController?.value.isInitialized ?? false
                ? VideoPlayer(_videoPlayerController!)
                : const Center(child: CircularProgressIndicator()),
          ),
          if (widget.isLastVideo)
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: widget.onVideoEnd,
                child: const Text('Terminar'),
              ),
            )
          else
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _playNextVideo,
              ),
            ),
        ],
      ),
    );
  }
}
