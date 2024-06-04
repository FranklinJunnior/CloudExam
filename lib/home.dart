import 'package:flutter/material.dart';
import 'package:project/video.dart';

class HomePage extends StatelessWidget {
  final String email;
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
  ];

  HomePage({required this.email});

  void _onVideoEnd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Gracias por ver los videos'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¡Gracias por ver los videos!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TikTok Clone'),
      ),
      body: PageView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            videoUrls: videos,
            currentIndex: index,
            email: email,
            onVideoEnd: () {
              if (index == videos.length - 1) {
                _onVideoEnd(context); // Mostrar el mensaje al final del último video
              }
            },
            isLastVideo: index == videos.length - 1,
          );
        },
      ),
    );
  }
}
