import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/videos/views/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";

  const VideoRecordingScreen({super.key});
  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _permissionDenied = false;
  bool _isSelfieMode = false;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 300,
    ),
  );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );
  late FlashMode _flashMode;

  late CameraController _cameraController;

  double _maxZoomLevel = 1;
  double _minZoomLevel = 1;
  double _zoomLevel = 1;

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
      enableAudio: true,
      // 음소거

      //# camerAwesome 추천함. camera패키지보다 기능도 많고 쉬움

      // _cameraController.getMaxZoomLevel(); .setZoomLevel.. 이용
    );
    await _cameraController.initialize();

    //ios만 설정 필요(오디오 싱크 안맞는 문제 때문에)
    await _cameraController.prepareForVideoRecording();

    _flashMode = _cameraController.value.flashMode;

    _maxZoomLevel = await _cameraController.getMaxZoomLevel();
    _minZoomLevel = await _cameraController.getMinZoomLevel();
    setState(() {});
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

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
    WidgetsBinding.instance.addObserver(this); // 유저 떠남 감지

    _progressAnimationController.addListener(() {
      setState(() {});
    });

    //addStatusListener : 애니메이션이 끝나는 시점을 알 수 있음.
    _progressAnimationController.addStatusListener((status) {
      // print(status);
      // 눌렀을때 forward
      // 완료 completed
      // 끝났을때 dismissed
      if (status == AnimationStatus.completed) {
        _onStopRecording();
      }
    });
  }

  bool _prepareDispose = false;

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission) return; // permission 되지 않은 상황일 때 리턴처리
    if (!_cameraController.value.isInitialized) return;
    //컨트롤러 이닛 안됐을 때도 리턴처리

    // print(state);
    // 떠날 때 : inactive paused
    // 돌아올 때 : inactive resumed

    if (state == AppLifecycleState.inactive) {
      _prepareDispose = true;
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _prepareDispose = false;
      initCamera();
    }
  }

  Future<void> _onStartRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _onStopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    //참고: 사진찍는 경우 _camerController.takePhoto()

    // print(video.name);
    //REC_D81CEDED-390A-4BA2-8A4E-345FB9079482.mp4
    // print(video.path);
    //...경로/REC_D81CEDED-390A-4BA2-8A4E-345FB9079482.mp4

    if (!mounted) return; // async 함수에서 context 쓰는 경고 해결
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => VidoePreviewScreen(
              video: video,
              isPicked: false,
            )),
      ),
    );
  }

  @override
  void dispose() {
    //항상 컨트롤러는 디스포즈하자 리소스 관리!
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();

    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery, // .camera 카메라 어플 실행
    );

    if (video == null) return;
    if (!mounted) return; // async 함수에서 context 쓰는 경고 해결
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => VidoePreviewScreen(
              video: video,
              isPicked: true,
            )),
      ),
    );
  }

  void _controllZoomLevel(DragUpdateDetails details) {
    final deltaY = details.delta.dy;
    if (deltaY >= 0) {
      if (_zoomLevel <= _minZoomLevel) return;
      _zoomLevel = double.parse(_zoomLevel.toStringAsFixed(2)) - 0.05;
    } else if (deltaY < 0) {
      if (_zoomLevel >= _maxZoomLevel) return;
      _zoomLevel = double.parse(_zoomLevel.toStringAsFixed(2)) + 0.05;
    }
    // print(_zoomLevel);

    _cameraController.setZoomLevel(_zoomLevel);

    setState(() {});
  }

  // final String _last = '';

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
                        //https://nomadcoders.co/tiktok-clone/lectures/4318/issues/4563
                        // 계속 dispose에러.
                        if (!_prepareDispose) CameraPreview(_cameraController),
                        const Positioned(
                          top: Sizes.size20,
                          left: Sizes.size20,
                          child: CloseButton(
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: Sizes.size20,
                          right: Sizes.size20,
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: _toggleSelfieMode,
                                color: Colors.white,
                                icon: const Icon(
                                  Icons.cameraswitch,
                                ),
                              ),
                              Gaps.v10,
                              IconButton(
                                onPressed: (() => _setFlashMode(
                                      FlashMode.off,
                                    )),
                                color: _flashMode == FlashMode.off
                                    ? Colors.amber.shade300
                                    : Colors.white,
                                icon: const Icon(
                                  Icons.flash_off_rounded,
                                ),
                              ),
                              IconButton(
                                onPressed: (() => _setFlashMode(
                                      FlashMode.always,
                                    )),
                                color: _flashMode == FlashMode.always
                                    ? Colors.amber.shade300
                                    : Colors.white,
                                icon: const Icon(
                                  Icons.flash_on_rounded,
                                ),
                              ),
                              IconButton(
                                onPressed: (() => _setFlashMode(
                                      FlashMode.auto,
                                    )),
                                color: _flashMode == FlashMode.auto
                                    ? Colors.amber.shade300
                                    : Colors.white,
                                icon: const Icon(
                                  Icons.flash_auto_rounded,
                                ),
                              ),
                              IconButton(
                                onPressed: (() => _setFlashMode(
                                      FlashMode.torch,
                                    )),
                                color: _flashMode == FlashMode.torch
                                    ? Colors.amber.shade300
                                    : Colors.white,
                                icon: const Icon(
                                  Icons.flashlight_on_rounded,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          width: MediaQuery.of(context).size.width,
                          bottom: 10,
                          child: Row(
                            children: [
                              // 아무것도 없이 빈공간을 차지하게
                              // 녹화버튼과 이미지버튼을 우측으로 밀어냄
                              const Spacer(),
                              GestureDetector(
                                onVerticalDragUpdate: _controllZoomLevel,
                                onTapDown: _onStartRecording,
                                onTapUp: (details) => _onStopRecording(),
                                onLongPressEnd: (details) => _onStopRecording(),
                                child: ScaleTransition(
                                  scale: _buttonAnimation,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: Sizes.size80 + Sizes.size14,
                                        height: Sizes.size80 + Sizes.size14,
                                        child: CircularProgressIndicator(
                                          // 우왕 벨류로 진행도 컨트롤 가능
                                          value: _progressAnimationController
                                              .value,
                                          color: Colors.red.shade400,
                                          strokeWidth: Sizes.size6,
                                        ),
                                      ),
                                      Container(
                                        width: Sizes.size80,
                                        height: Sizes.size80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                //얘는 Exapaded돼서 우측 차지
                                child: Container(
                                  //Container에 넣어서 터치 가능 영역 줄이기
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    onPressed: _onPickVideoPressed,
                                    icon: const FaIcon(
                                      FontAwesomeIcons.image,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

/*
## didChangeAppLifecycleState
위 메서드는 WidgetsBindingObserver <- 여기에 있어서 mixin해줘야 함.
시스템이 앱을 백그라운드로 보내거나 다시 돌아올 때 호출하기 때문임.


## 어플 지우고 리빌드해보면...

퍼미션 알러트 뜨면서 앱에 에러 발생

camera controller가 initilize 되지 않았을 때 접근하고 있음

app start -> initState : permission 가져옴 -> 컨트롤러 이니셜라이즈

해결방법 : cam controller가 이니셜라이즈 되지 않음을 확인 (didChange...에서 확인)

*/
