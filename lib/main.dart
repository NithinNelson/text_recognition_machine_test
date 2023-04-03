import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:text_recognition_machine_test/screens/MyHomePage.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayOpacity: 0.6,
      overlayColor: Colors.grey,
      overlayWidget: SpinKitFadingCircle(
        color: Colors.purple,
        // color: Colors.blue,
      ),
      useDefaultLoading: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Text Recognition',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
