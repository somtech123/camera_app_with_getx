import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/camera_control.dart';
import 'package:camera_app/camera_utils.dart';
import 'package:camera_app/photo_preview.dart';
import 'package:camera_app/video_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List? cameras;
  int? selectedCameraIndex;

  bool _isRecording = false;
  bool _isLongPressed = false;

  String? _videoPath;

  Timer? _timer;
  int _secondsElapsed = 0;
  File? image;
  File? videoPath;
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    _initAvailableCamera();
  }

  _initAvailableCamera() {
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras!.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras![selectedCameraIndex!]).then((void v) {});
      } else {
        debugPrint('No camera available');
      }
    }).catchError((err) {
      debugPrint('Error :${err.code}Error message : ${err.message}');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    _controller!.setFlashMode(FlashMode.auto);

    _controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_controller!.value.hasError) {
        debugPrint('Camera error ${_controller!.value.errorDescription}');
      }
    });
    try {
      await _controller!.initialize();
    } on CameraException catch (e) {
      showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: _cameraPreviewWidget(),
          ),
          backControl(context),
          toolBar(context),
          Visibility(
            visible: _isRecording == true,
            child: timerWidget(
              context,
              text: _formatTime(30 - _secondsElapsed),
            ),
          ),
          //   cameraShutter
          CameraShutter(
            //  context,
            switchCamera: () => _onSwitchCamera(),
            isRecording: _isRecording,
            takeImage: () {
              if (_isRecording == false && _isLongPressed == false) {
                _caputureStory();
                debugPrint(' picture');
              }
            },
            recordVideo: () {
              if (_controller!.value.isInitialized) {
                if (!_controller!.value.isRecordingVideo) {
                  debugPrint(' RECORDING');

                  startRecording();
                } else {
                  _stopRecording();
                  debugPrint('NOT RECORDING');
                }
              }
            },
          )
        ],
      )),
    );
  }

  _caputureStory() async {
    try {
      if (!_controller!.value.isInitialized) {
        return null;
      }

      final picked = await _controller!.takePicture();
      if (picked != null) {
        image = File(picked.path);

        Get.to(() => PhotoPreview(image: image!));
      }
    } on CameraException catch (e) {
      showCameraException(e);
    }
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_secondsElapsed >= 30) {
          _stopRecording();
          setState(() {});
          Fluttertoast.showToast(msg: 'Video recording stopped');
        } else {
          _secondsElapsed++;
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  void _stopRecording() async {
    if (_controller!.value.isRecordingVideo) {
      try {
        final picked = await _controller!.stopVideoRecording();

        _stopTimer();

        setState(() {
          _isRecording = false;
          _isLongPressed = false;
        });

        if (picked != null) {
          videoPath = File(picked.path);

          Get.to(() => VideoPlayerScreen(videoPath: videoPath!));
        }
      } on CameraException catch (e) {
        showCameraException(e);
      }
    }
  }

  void startRecording() async {
    if (_controller!.value.isInitialized &&
        !_controller!.value.isRecordingVideo) {
      try {
        await _controller!.startVideoRecording();
        setState(() {
          _isRecording = true;
          _isLongPressed = true;
        });
        _startTimer();
        setState(() {
          _isRecording = true;

          debugPrint(_videoPath);
        });
      } on CameraException catch (e) {
        showCameraException(e);
      }
    }
  }

  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return waitingWidget(context);
    }
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    );
  }

  void _onSwitchCamera() {
    selectedCameraIndex = selectedCameraIndex! < cameras!.length - 1
        ? selectedCameraIndex! + 1
        : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIndex!];
    _initCameraController(selectedCamera);
  }
}
