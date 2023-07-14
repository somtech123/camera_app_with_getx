import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void showCameraException(CameraException e) {
  String errorText = 'Error:${e.code}\nError message : ${e.description}';
  debugPrint(errorText);
}

Widget waitingWidget(BuildContext context) {
  return Center(
    child: Text(
      'Loading',
      style: Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black),
    ),
  );
}
