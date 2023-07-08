import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AddFieldPage extends StatefulWidget {
  @override
  _AddFieldPageState createState() => _AddFieldPageState();
}
class _AddFieldPageState extends State<AddFieldPage> {
  bool added = false;
  bool failed = false;
  String message = "";

  TextEditingController yieldTypeController = TextEditingController();
  TextEditingController yieldSizeController = TextEditingController();
  TextEditingController fieldAddressController = TextEditingController();

  Future<void> addField() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';


    final url = Uri.parse('http://192.168.1.10:8080/addField');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$email:$password'))}',
    };
    try{
      final body = jsonEncode({
        'plantDTO': yieldTypeController.text,
        'sizeDTO': int.parse(yieldSizeController.text),
        'addressDTO': fieldAddressController.text,

      });
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Field added successfully.');
        message = 'Field added successfully.';
        setState(() {
          added = true;
          failed = false;
        });

      } else {
        print('Failed to add field. status code:${response.statusCode}');
        message = 'Failed to add field.';
        setState(() {
          failed = true;
          added = false;
        });
      }
    }catch(e){
      print('Error: $e');
      message = 'Failed to add field.';
      setState(() {
        failed = true;
        added = false;
      });
    }


    yieldTypeController.clear();
    yieldSizeController.clear();
    fieldAddressController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Field'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Visibility(
              visible: added,
              child: Container(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: failed,
              child: Container(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            TextField(
              controller: yieldTypeController,
              decoration: InputDecoration(
                labelText: 'Yield Type',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: yieldSizeController,
              decoration: InputDecoration(
                labelText: 'Yield Size',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: fieldAddressController,
              decoration: InputDecoration(
                labelText: 'Field Address',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                addField();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}


