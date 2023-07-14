import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

Widget backControl(BuildContext context) {
  return Positioned(
    child: GestureDetector(
      child: SvgPicture.asset('assets/svgs/toolbars.svg'),
      onTap: () => Get.back(),
    ),
  );
}

Widget toolBar(BuildContext context) {
  return Positioned(
    top: Get.height / 2,
    left: 12.h,
    child: SvgPicture.asset('assets/svgs/story buttons.svg'),
  );
}

Widget timerWidget(BuildContext context, {required String text}) {
  return Positioned(
    height: 20.h,
    left: Get.width / 2 - 30.w,
    child: Container(
      height: 30.h,
      width: 50.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white, fontSize: 15.sp),
      ),
    ),
  );
}

class CameraShutter extends StatelessWidget {
  CameraShutter(
      {required this.switchCamera,
      required this.takeImage,
      required this.recordVideo,
      this.isRecording = false});

  Future<bool> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<List<AssetEntity>> getAllDeviceImages() async {
    final permitted = await requestPermission();
    if (!permitted) {
      Fluttertoast.showToast(msg: 'Permission is not accessible.');
      return [];
    }

    final albums = await PhotoManager.getAssetPathList(onlyAll: true);

    final assetList = await albums[0].getAssetListRange(start: 0, end: 1000000);

    final imageList =
        assetList.where((asset) => asset.type == AssetType.image).toList();

    return imageList;
  }

  final VoidCallback switchCamera;

  final VoidCallback takeImage;

  final VoidCallback recordVideo;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.h,
      left: 30.w,
      child: Row(
        children: [
          FutureBuilder(
            future: getAllDeviceImages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final images = snapshot.data;
                return Container(
                  height: 77.h,
                  width: 77.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 75.h,
                        width: 75.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetEntityImageProvider(images![0]),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                );
              } else {
                return SizedBox(
                  height: 77.h,
                  width: 77.w,
                );
              }
            },
          ),
          SizedBox(width: 30.w),
          GestureDetector(
            onTap: takeImage,
            onLongPress: recordVideo,
            child: SvgPicture.asset(
              'assets/svgs/ic_shutter_camera.svg',
              height: 120.h,
              color: isRecording == false
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 30.w),
          GestureDetector(
            onTap: switchCamera,
            child: SvgPicture.asset(
              'assets/svgs/change-photo.svg',
              height: 70.h,
            ),
          ),
        ],
      ),
    );
  }
}

Widget cameraShutter(
  BuildContext context, {
  required VoidCallback switchCamera,
  required VoidCallback takeImage,
  required VoidCallback recordVideo,
  bool isRecording = false,
}) {
  return Positioned(
    bottom: 10.h,
    left: 30.w,
    child: Row(
      children: [
        Container(
          height: 77.h,
          width: 77.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 75.h,
                width: 75.w,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/profile.jpg')),
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
        ),
        SizedBox(width: 30.w),
        GestureDetector(
          onTap: takeImage,
          onLongPress: recordVideo,
          child: SvgPicture.asset(
            'assets/svgs/ic_shutter_camera.svg',
            height: 120.h,
            color: isRecording == false
                ? Colors.white
                : Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(width: 30.w),
        GestureDetector(
          onTap: switchCamera,
          child: SvgPicture.asset(
            'assets/svgs/change-photo.svg',
            height: 70.h,
          ),
        ),
      ],
    ),
  );
}
