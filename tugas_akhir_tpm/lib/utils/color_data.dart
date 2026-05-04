import 'package:flutter/material.dart';

class ColorData {
  final Color color;
  final String name;
  final String undertone; // warm / cool / neutral

  ColorData(this.color, this.name, this.undertone);
}

final List<ColorData> colorBank = [
  ColorData(Color(0xFFD4785A), 'Terracotta', 'warm'),
  ColorData(Color(0xFFE890C0), 'Rose Pink', 'cool'),
  ColorData(Color(0xFF8B6248), 'Mocha Brown', 'warm'),
  ColorData(Color(0xFF8090C0), 'Dusty Blue', 'cool'),
  ColorData(Color(0xFFFF6B8A), 'Hot Pink', 'cool'),
  ColorData(Color(0xFFA8D4B8), 'Mint', 'cool'),
  ColorData(Color(0xFFD4A76A), 'Camel', 'warm'),
];