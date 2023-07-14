import 'package:camera_app/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: '',
            home: HomePage(),
            // getPages: AppRoutes.appPages,
            theme: ThemeData(primaryColor: Colors.blue),
            smartManagement: SmartManagement.keepFactory));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Get.to(() => CameraScreen());
            },
            child: Text(
              'take photo',
            )),
      ),
    );
  }
}
