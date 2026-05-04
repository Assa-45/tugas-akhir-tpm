class AnalysisMapper {
  static Map<String, dynamic> mapAll(Map<String, dynamic> data) {
    final undertone = data['undertone'] ?? 'neutral';
    final brightness = data['brightness'] ?? 'medium';
    final contrast = data['contrast_level'] ?? 'medium';

    return {
      "faceFeatures": _faceFeatures(data),
      "harmony": _harmony(undertone, brightness, contrast),
      "makeup": _makeup(undertone, brightness),
      "accessories": _accessories(undertone),
    };
  }

  /// FACE FEATURES
  static List<Map<String, String>> _faceFeatures(Map data) {
    return [
      {
        "label": data['undertone'] == "warm"
            ? "Warm Golden"
            : data['undertone'] == "cool"
                ? "Cool Pink"
                : "Neutral",
        "sub": "Skin"
      },
      {
        "label": "Natural Tone",
        "sub": "Eyes"
      },
      {
        "label": "Deep Tone",
        "sub": "Hair"
      },
    ];
  }

  /// HARMONY BAR (0 - 1)
  static Map<String, double> _harmony(
      String undertone, String brightness, String contrast) {
    return {
      "warmCool": undertone == "warm"
          ? 0.8
          : undertone == "cool"
              ? 0.2
              : 0.5,
      "mutedBright": brightness == "dark"
          ? 0.3
          : brightness == "light"
              ? 0.7
              : 0.5,
      "deepLight": brightness == "dark"
          ? 0.8
          : brightness == "light"
              ? 0.2
              : 0.5,
      "softClear": contrast.contains("high") ? 0.7 : 0.4,
    };
  }

  /// MAKEUP GUIDE
  static Map<String, List<Map>> _makeup(String undertone, String brightness) {
    if (undertone == "warm") {
      return {
        "foundation": [
          {"name": "Warm Beige", "color": 0xFFE8C4A0},
          {"name": "Golden Sand", "color": 0xFFD4A878},
        ],
        "blush": [
          {"name": "Peach", "color": 0xFFE8A090},
          {"name": "Terracotta", "color": 0xFFC87060},
        ],
        "lips": [
          {"name": "Brick Rose", "color": 0xFFC06050},
        ],
      };
    }

    return {
      "foundation": [],
      "blush": [],
      "lips": [],
    };
  }

  /// ACCESSORIES
  static Map<String, List<String>> _accessories(String undertone) {
    if (undertone == "warm") {
      return {
        "metals_best": ["Gold", "Rose Gold"],
        "metals_avoid": ["Silver"],
      };
    }

    return {
      "metals_best": ["Silver"],
      "metals_avoid": ["Gold"],
    };
  }
}