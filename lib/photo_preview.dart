import 'dart:io';

import 'package:camera_app/camera_control.dart';
import 'package:camera_app/shared_widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PhotoPreview extends StatelessWidget {
  PhotoPreview({super.key, required this.image});
  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              image: image != null
                  ? DecorationImage(
                      image: FileImage(
                        image,
                      ),
                      fit: BoxFit.cover)
                  : null,
            ),
          ),
          backControl(context),
          Positioned(
            bottom: 10.h,
            left: 0.0.h,
            right: 0.0.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
      )),
    );
  }
}
