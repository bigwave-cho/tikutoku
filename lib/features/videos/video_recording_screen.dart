import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  bool _permissionDenied = false;
  bool _isSelfieMode = false;

  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras(); //camera list

    if (cameras.isEmpty) return;

    // debugPrint('$cameras'); 첫번째가 back 두번째가 front임. 확인!
    //CameraController(description, resolutionPreset)
    // des : 카메라리스트 중 하나 골라
    // res : 화질 프리셋
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );

    await _cameraController.initialize();
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();
    //안드는 거절하면 매번 다시 요청
    // ios는 한번 끝. 나중엔 설정가서 허용해야함.
    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      _permissionDenied = true;
      setState(() {});
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: _permissionDenied
              ? Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "camera permission is required.",
                      ),
                    ),
                  ],
                )
              : !_hasPermission || !_cameraController.value.isInitialized
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Initiallizing",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size20,
                          ),
                        ),
                        Gaps.v20,
                        CircularProgressIndicator.adaptive(),
                      ],
                    )
                  : Stack(
                      // 꽉채우려고 넣었는데 비율이 안맞게 늘어남.. ㅋㅋ
                      // fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        CameraPreview(_cameraController),
                        Positioned(
                          top: Sizes.size40,
                          right: Sizes.size20,
                          child: IconButton(
                            onPressed: _toggleSelfieMode,
                            color: Colors.white,
                            icon: const Icon(
                              Icons.cameraswitch,
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
