import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';

Map<String, dynamic> extractSkinColor(String path, Face face) {
  final image = img.decodeImage(File(path).readAsBytesSync());

  if (image == null) {
    throw Exception("Image decode failed");
  }

  final rect = face.boundingBox;

  int startX = rect.left.toInt();
  int startY = rect.top.toInt();
  int endX = rect.right.toInt();
  int endY = rect.bottom.toInt();

  startX = startX.clamp(0, image.width - 1);
  endX   = endX.clamp(0, image.width - 1);
  startY = startY.clamp(0, image.height - 1);
  endY   = endY.clamp(0, image.height - 1);

  int r = 0, g = 0, b = 0, count = 0;

  for (int y = startY; y < endY; y += 5) {
    for (int x = startX; x < endX; x += 5) {
      final pixel = image.getPixel(x, y);

      r += pixel.r.toInt();
      g += pixel.g.toInt();
      b += pixel.b.toInt();
      count++;
    }
  }

  if (count == 0) {
    throw Exception("No pixels sampled");
  }

  r ~/= count;
  g ~/= count;
  b ~/= count;

  return analyzeColor(r, g, b);
}

Map<String, dynamic> analyzeColor(int r, int g, int b) {
  String undertone;

  if ((r - b) > 20) {
    undertone = "warm";
  } else if ((b - r) > 10) {
    undertone = "cool";
  } else {
    undertone = "neutral";
  }

  double brightness = (r + g + b) / 3;

  String brightnessLevel;
  if (brightness > 180) {
    brightnessLevel = "light";
  } else if (brightness > 120) {
    brightnessLevel = "medium";
  } else {
    brightnessLevel = "dark";
  }

  return {
    "undertone": undertone,
    "brightness": brightnessLevel,
    "skin_rgb": [r, g, b],
    "confidence": 0.8,
  };
}