import 'dart:io';

import 'package:camera_app/shared_widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'camera_control.dart';
import 'camera_utils.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({super.key, required this.videoPath});
  File videoPath;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.videoPath)
      ..initialize().then((value) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
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
              child: _videoPreviewWidget(),
            ),
            backControl(context),
            VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Theme.of(context).primaryColor,
              ),
            ),
            _controlOverlay(),
            Positioned(
              bottom: 10.h,
              left: 0.0.h,
              right: 0.0.h,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.8,
                      child: CustomTextField(
                        hintText: 'Add a caption...',
                        onChanged: (value) {},
                        fillColor: Colors.white,
                        borderRadius: 25.h,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/svgs/share.svg',
                          color: Theme.of(context).primaryColor,
                          height: 40.h,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlOverlay() {
    return Positioned(
      top: Get.height / 2,
      left: Get.width / 2,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          size: 40.h,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _videoPreviewWidget() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return waitingWidget(context);
    }
    return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!));
  }
}
