import 'package:hive/hive.dart';
import '../models/analysisresult_model.dart';

class HiveService {
  final Box analysisBox = Hive.box('analysisBox');

  Future<void> saveAnalysis(AnalysisResult data) async {
    await analysisBox.put(data.id, data);
  }

  List<AnalysisResult> getAllAnalysis() {
    return analysisBox.values.cast<AnalysisResult>().toList();
  }
}