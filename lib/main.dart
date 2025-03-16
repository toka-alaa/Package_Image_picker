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
  bool isVideo = false;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: selectedFile != null
                    ? isVideo
                        ? (videoController != null &&
                                videoController!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: videoController!.value.aspectRatio,
                                child: VideoPlayer(videoController!),
                              )
                            : const CircularProgressIndicator())
                        : Image.file(selectedFile!,
                            errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image,
                                size: 100, color: Colors.red);
                          })
                    : const Icon(Icons.image, size: 100, color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text(
                "Image Picker",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              CustomButton(
                  icon: Icons.photo,
                  text: "Pick Image from Gallery",
                  onPressed: () => getImage(ImageSource.gallery)),
              const SizedBox(height: 10),
              CustomButton(
                  icon: Icons.camera_alt,
                  text: "Pick Image from Camera",
                  onPressed: () => getImage(ImageSource.camera)),
              const SizedBox(height: 10),
              CustomButton(
                  icon: Icons.video_library,
                  text: "Pick Video from Gallery",
                  onPressed: () => getVideo(ImageSource.gallery)),
              const SizedBox(height: 10),
              CustomButton(
                  icon: Icons.videocam,
                  text: "Pick Video from Camera",
                  onPressed: () => getVideo(ImageSource.camera)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getVideo(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickVideo(source: source);
    if (media == null) return;

    setState(() {
      selectedFile = File(media.path);
      isVideo = true;
      videoController?.dispose();
      videoController = VideoPlayerController.file(selectedFile!)
        ..initialize().then((_) {
          setState(() {});
          videoController!.play();
        });
    });
  }

  Future<void> getImage(ImageSource source) async {
    final returnedImage = await ImagePicker().pickImage(source: source);
    if (returnedImage == null) return;

    setState(() {
      selectedFile = File(returnedImage.path);
      isVideo = false;
      videoController?.dispose();
      videoController = null;
    });
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: MaterialButton(
        onPressed: onPressed,
        color: Colors.white,
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(text,
                style: const TextStyle(fontSize: 20, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
