import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/getFieldAnalysis.dart';
import 'package:untitled/uploadMedia.dart';
import 'dart:convert';
import 'Field.dart';

class FieldList extends StatefulWidget {
  @override
  _FieldListState createState() => _FieldListState();
}

class _FieldListState extends State<FieldList> {
  List<Field> fields = [];

  @override
  void initState() {
    super.initState();
    fetchFields();
  }

  void saveFieldInfo(int fieldId, String fieldPlant, int fieldSize, String fieldAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fieldId', fieldId.toString());
    await prefs.setString('fieldPlant', fieldPlant);
    await prefs.setString('fieldSize', fieldSize.toString());
    await prefs.setString('fieldAddress', fieldAddress);
  }

  Future<void> fetchFields() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      String password = prefs.getString('password') ?? '';

      final response = await http.get(
        Uri.parse('http://192.168.1.10:8080/getFields'),
        headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('$email:$password'))}'},
      );

      if (response.statusCode == 200) {
        // Parse the response
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          fields = data.map((item) => Field.fromJson(item)).toList();
        });
        for (int i = 0; i < fields.length; i++) {
          final field = fields[i];
          saveFieldInfo(field.fieldId, field.plant, field.size, field.address);
        }
      } else {
        print('Error fetching fields');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Fields'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: fields.length == 0
            ? Center(
          child: Text(
            'No field added',
            style: TextStyle(fontSize: 18.0),
          ),
        )
            : ListView.builder(
          itemCount: fields.length,
          itemBuilder: (context, index) {
            final field = fields[index];
            return Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(
                  'Field ID: ${field.fieldId}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text('Plant: ${field.plant}'),
                    SizedBox(height: 4.0),
                    Text('Size: ${field.size}'),
                    SizedBox(height: 4.0),
                    Text('Address: ${field.address}'),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  Field.setField(field);
                                  return UploadMedia(field: field);
                                },
                              ),
                            );
                          },
                          child: Text('Analyze'),
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                        ),
                        SizedBox(width: 150),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  Field.setField(field);
                                  return GetFieldAnalysisPage(field: field);
                                },
                              ),
                            );
                          },
                          child: Text('History'),
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
