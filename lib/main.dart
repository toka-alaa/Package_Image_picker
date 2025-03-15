import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyPackage());
}

class MyPackage extends StatefulWidget {
  const MyPackage({super.key});

  @override
  State<MyPackage> createState() => _MyPackageState();
}

class _MyPackageState extends State<MyPackage> {
  File? selectedFile;
  VideoPlayerController? videoController;

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: Column(
            spacing: 30,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: selectedFile != null
                    ? (videoController != null
                        ? AspectRatio(
                            aspectRatio: videoController!.value.aspectRatio,
                            child: VideoPlayer(videoController!),
                          )
                        : Image.file(selectedFile!))
                    : const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.black,
                      ),
              ),
              Text(
                "Image Picker",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: MaterialButton(
                  onPressed: () {
                    pickMedia(ImageSource.gallery);
                  },
                  elevation: 5,
                  color: Colors.white,
                  child: Row(
                    spacing: 20,
                    children: [
                      Icon(Icons.photo),
                      const Text('Pick gallery',
                          style: TextStyle(fontSize: 25, color: Colors.black)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: MaterialButton(
                  onPressed: () {
                    galleryImage(ImageSource.camera);
                  },
                  color: Colors.white,
                  elevation: 5,
                  child: Row(
                    spacing: 20,
                    children: [
                      Icon(Icons.camera_alt),
                      const Text('Pick camera',
                          style: TextStyle(fontSize: 25, color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickMedia(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? media = await picker.pickMedia();
    if (media == null) return;

    setState(() {
      selectedFile = File(media.path);
    });
  }

  Future<void> galleryImage(ImageSource source) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedFile = File(returnedImage.path);
    });
  }

  Future<void> cameraImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      selectedFile = File(returnedImage.path);
    });
  }
}
