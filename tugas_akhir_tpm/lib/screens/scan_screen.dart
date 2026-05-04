import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../services/facedetector_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCam, ResolutionPreset.medium);
    await _controller!.initialize();

    if (mounted) setState(() {});
  }

  Future<void> captureAndProcess() async {
    setState(() => isProcessing = true);

    final file = await _controller!.takePicture();

    final result = await processImage(file.path);

    print(result); // nanti dikirim ke API

    setState(() => isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),

          Stack(
            children: [
              CameraPreview(_controller!),

              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: const Offset(0, -80), 
                  child: Container(
                    width: 250,
                    height: 320,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Text(
              "Align your face inside the frame",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: captureAndProcess,
                child: const Text("Scan"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}