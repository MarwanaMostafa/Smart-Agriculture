import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Field.dart';
import 'FieldAnalysis.dart';

class GetFieldAnalysisPage extends StatefulWidget {
  final Field field;
  GetFieldAnalysisPage({@required this.field});

  @override
  _GetFieldAnalysisPageState createState() => _GetFieldAnalysisPageState();
}

class _GetFieldAnalysisPageState extends State<GetFieldAnalysisPage> {
  Field field;
  List<FieldAnalysis> fieldAnalysisList = [];

  void saveFieldAnalysisID(int fieldAnalysisId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('field_analysis_id', fieldAnalysisId);
  }

  Future<void> fetchFieldAnalysis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = Uri.parse('http://192.168.1.10:8080/getFieldAnalysis/?FieldID=${Field.getCurrentField().fieldId}');
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$email:$password'))}',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<FieldAnalysis> fieldAnalysisData = responseData.map((data) => FieldAnalysis.fromJson(data)).toList();
        setState(() {
          fieldAnalysisList = fieldAnalysisData;
        });
        setState(() {
          for (int i = 0; i < fieldAnalysisList.length; i++) {
            final fieldAnalysis = fieldAnalysisList[i];
            saveFieldAnalysisID(fieldAnalysis.fieldAnalysisId);

          }
        });

      } else {
        print('Failed to fetch field analysis. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFieldAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Field Analysis'),
      ),
      body: fieldAnalysisList.isEmpty
          ? Center(
        child: Text(
          'No field analysis.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: fieldAnalysisList.length,
        itemBuilder: (context, index) {
          final fieldAnalysis = fieldAnalysisList[index];
          return Card(
            elevation: 2.0,
            child: ListTile(
              title: Text(
                'Analysis ID: ${fieldAnalysis.fieldAnalysisId}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text('Date: ${fieldAnalysis.date}'),
                  Text('Total Disease Percentage: ${fieldAnalysis.totalDiseasePercentage}'),
                  Text('Healthy Percentage: ${fieldAnalysis.healthyPercentage}'),
                  Text('Pepper Bacterial Spot Percentage: ${fieldAnalysis.pepperBacterialSpotPercentage}'),
                  Text('Strawberry Leaf Scorch Percentage: ${fieldAnalysis.strawberryLeafScorchPercentage}'),

                ],
              ),

            ),
          );
        },
      ),
    );
  }
}
