import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VidoePreviewScreen extends StatefulWidget {
  final XFile video;

  const VidoePreviewScreen({
    super.key,
    required this.video,
  });

  @override
  State<VidoePreviewScreen> createState() => _VidoePreviewScreenState();
}

class _VidoePreviewScreenState extends State<VidoePreviewScreen> {
  late final VideoPlayerController _videoPlayerController;
  Future<void> _initVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.video.path));

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    // 에뮬레이터에서 소리 켠채로 녹화하면 잘 안됨 걍 실기기로 해라

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Preview video"),
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
