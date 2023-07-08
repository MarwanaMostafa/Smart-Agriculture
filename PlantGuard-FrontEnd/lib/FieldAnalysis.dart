import 'package:flutter/cupertino.dart';

class FieldAnalysis {
  int fieldAnalysisId;
  final int totalDiseasePercentage;
  final int healthyPercentage;
  final String date;
  final int pepperBacterialSpotPercentage;
  final int strawberryLeafScorchPercentage;

  FieldAnalysis({
    @required this.fieldAnalysisId,
    @required this.totalDiseasePercentage,
    @required this.healthyPercentage,
    @required this.date,
    @required this.pepperBacterialSpotPercentage,
    @required this.strawberryLeafScorchPercentage,
  });


  factory FieldAnalysis.fromJson(Map<String, dynamic> json) {
    return FieldAnalysis(
      fieldAnalysisId: json['field_analysis_id'],
      totalDiseasePercentage: json['total_disiese_percenatge'],
      healthyPercentage: json['heathy_percenatge'],
      date: json['date'],
      pepperBacterialSpotPercentage: json['pepper_Bacterial_spot_percenatge'],
      strawberryLeafScorchPercentage: json['strawberry_Leaf_scorch_percenatge'],
    );
  }
}