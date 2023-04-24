import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

class VidoePreviewScreen extends StatefulWidget {
  final XFile video;
  // 촬영 후 온건지 갤러리에서 선택했는지 여부 확인
  final bool isPicked;

  const VidoePreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  State<VidoePreviewScreen> createState() => _VidoePreviewScreenState();
}

class _VidoePreviewScreenState extends State<VidoePreviewScreen> {
  bool _savedVideo = false;

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

  Future<void> _saveToGallery() async {
    if (_savedVideo) return;
    await GallerySaver.saveVideo(
      widget.video.path,
      albumName: "TikTok Clone!",
    );
    _savedVideo = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Preview video"),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _savedVideo
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.download,
              ),
            ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}

/*
# Gallery Saver
## https://pub.dev/packages/gallery_saver
설명 잘 보고 안드랑 ios 파일 수정필요.
 */