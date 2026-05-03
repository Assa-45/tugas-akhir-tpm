import 'package:hive/hive.dart';

part 'analysisresult_model.g.dart';

@HiveType(typeId: 1)
class AnalysisResult extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String imagePath;

  @HiveField(2)
  String undertone;

  @HiveField(3)
  String season;

  @HiveField(4)
  List<int> palette; // simpan warna sebagai int

  @HiveField(5)
  DateTime createdAt;

  AnalysisResult({
    required this.id,
    required this.imagePath,
    required this.undertone,
    required this.season,
    required this.palette,
    required this.createdAt,
  });
}