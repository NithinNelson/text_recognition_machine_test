import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:text_recognition_machine_test/main.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:text_recognition_machine_test/screens/services/common_widgets.dart';
import 'package:text_recognition_machine_test/screens/text_showing_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  late InputImage inputImage;
  late XFile image;
  late String _extractedText;
  bool flash = false;
  var frontCam = cameras[1];
  var backCam = cameras[0];
  bool camera = false;

  Future<void> _getImage() async {
    context.loaderOverlay.show();
    image = await controller.takePicture();
    setState(() {
      inputImage = InputImage.fromFilePath(image.path);
    });
    _performOCR();
  }

  Future<void> _performOCR() async {
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    // final TextRecognizer textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognisedText = await textRecognizer.processImage(inputImage);
    // final RecognizedText recognisedText =
    //     await textDetector.processImage(inputImage);
    setState(() {
      _extractedText = recognisedText.text;
    });
    print("---------text------------$_extractedText");
    if (_extractedText != "") {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return TextShow(text: _extractedText);
      }));
    } else {
      snackBar(context, "No Text Recognized");
    }
    context.loaderOverlay.hide();
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() {
    controller = CameraController(
        camera ? cameras[1] : cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            snackBar(context, "Camera Access Denied");
            break;
          default:
            snackBar(context, "Camera Error");
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: CameraPreview(
                  controller,
                ),
              ),
              Flexible(flex: 1, child: Container()),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            camera = !camera;
                          });
                          _initialize();
                        },
                        icon: Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                        )),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () => _getImage(),
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            flash = !flash;
                          });
                          _tourch();
                        },
                        icon: Icon(
                          flash ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Flexible(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  _tourch() async {
    await controller.setFlashMode(flash ? FlashMode.torch : FlashMode.off);
  }
}
