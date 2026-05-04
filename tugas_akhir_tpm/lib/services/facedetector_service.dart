import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'extractcolor_service.dart';

Future<Map<String, dynamic>> processImage(String path) async {
  final inputImage = InputImage.fromFilePath(path);

  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  final faces = await faceDetector.processImage(inputImage);

  if (faces.isEmpty) {
    throw Exception("No face detected");
  }

  final face = faces.first;

  return extractSkinColor(path, face);
}