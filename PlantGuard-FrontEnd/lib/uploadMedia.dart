import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Field.dart';
import 'package:untitled/FieldAnalysis.dart';

import 'cameraApp.dart';


class UploadMedia extends StatefulWidget {
  final Field field;
  int fieldAnalysisId;
  FieldAnalysis fieldAnalysis;
  UploadMedia({@required this.field, @required this.fieldAnalysisId});


  @override
  _UploadMediaState createState() => _UploadMediaState();
}

class _UploadMediaState extends State<UploadMedia> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _image;
  File _video;
  final imagePicker = ImagePicker();
  String predictionResult = '';
  bool isVisible = false;
  bool errorMsg = false;
  String message = "";
  String errorMessage = "";
  int id = -1;
  List<CameraDescription> cameras;
  FieldAnalysis fieldAnalysis;

  // For initializing the camera with the available cameras
  Future<Null> testCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }



  void saveAnalysis(String disease, int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('disease', disease);
    await prefs.setString('count', count.toString());
  }

  void saveFieldAnalysisID(int fieldAnalysisId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('field_analysis_id', fieldAnalysisId);
  }

  Future<void> addFieldAnalysis() async{
    int number = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';
    String disease = prefs.getString('disease') ?? '';
    String count = prefs.getString('count') ?? '';

    final url = Uri.parse('http://192.168.1.10:8080/addFieldAnalysis?FieldID=${Field.getCurrentField().fieldId}&FieldAnalysisID=$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$email:$password'))}',
    };
    try{
      final body = jsonEncode({
        'disease': [
          [disease, count]
        ]

      });
      final response = await http.post(url, headers: headers, body: body);
      if(response.statusCode == 200){
        message = response.body;
        print(message);


          if(id==-1){
            int startIndex = message.indexOf(':') + 2;
            int endIndex = message.length;
            String numberString = message.substring(startIndex, endIndex);
            number = int.tryParse(numberString.trim());
          }else{
            number = id;
          }

          setState(() {
            id = number;
            isVisible = true;
            errorMsg = false;
            print(number);
          });



      }else{
        errorMessage = "Failed to add an analysis.";
        print(response.body);
        setState(() {
          errorMsg = true;
          isVisible = false;
        });
      }
    }catch(e){
      errorMessage = "Failed to add an analysis.";
      setState(() {
        errorMsg = true;
        isVisible = false;

      });

      print('Error: $e');
    }
  }


  Future getImageFromCamera() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
      _video = null;
    });
  }

  Future getImageFromGallery() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      _video = null;
    });
  }

  Future uploadImage() async {
    if (_image == null) {
      print("No image selected");
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.10:5000//api/predictions'), //flask server ip
    );


    request.files.add(await http.MultipartFile.fromPath(
      'image',
      _image.path,
      contentType: MediaType('image', path.extension(_image.path).substring(1)),
    ));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Handle the successful response
        String responseBody = await response.stream.bytesToString();
        var document = parse(responseBody);
        var predictionElement = document.getElementById('Prediction');
        if (predictionElement != null) {
          setState(() {
            try{
              predictionResult = predictionElement.text.toString();
              List<String> diseaseType = predictionResult.split(':');
              saveAnalysis(diseaseType[1], 1);
              addFieldAnalysis();
            }catch(e){
              print('Failed to add field analysis');
            }

          });
          print('Image uploaded successfully');
        }
      } else {
        errorMessage = 'Error during image upload';
        // Handle the error response
        print('Error during image upload. Status code: ${response.statusCode}');
        setState(() {
          errorMsg = true;
          isVisible = false;
        });
      }
    } catch (e) {
      errorMessage = 'Error during image upload';
      setState(() {
        errorMsg = true;
        isVisible = false;
      });
      print('Error during image upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text("Analyze field # ${Field.getCurrentField().fieldId}"),


    ),

    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'imageHero',
            child: _image == null && _video == null
                ? Text("No media selected")
                : _image != null
                ? Image.file(_image)
                : Icon(Icons.videocam),
          ),
          SizedBox(height: 16),
          Hero(
            tag: 'detectButtonHero',
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: uploadImage,
              child: Text('Detect Disease'),
            ),
          ),
          SizedBox(height: 16),
          Text(predictionResult),
          SizedBox(height: 16),
        ],
      ),
    ),
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Hero(

          tag: 'cameraButtonHero',
          child: FloatingActionButton(
            heroTag: null,
            onPressed: getImageFromCamera,
            backgroundColor: Colors.green,
            child: Icon(Icons.camera_alt),
          ),
        ),
        SizedBox(height: 16),
        Hero(
          tag: 'galleryButtonHero',
          child: FloatingActionButton(
            heroTag: null,
            onPressed: getImageFromGallery,
            backgroundColor: Colors.green,
            child: Icon(Icons.photo_library),
          ),
        ),
        SizedBox(height: 16),
        Hero(
          tag: 'videoCameraButtonHero',
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () async {
              await testCameras();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CameraScreen(cameras),
                ),
              );
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.videocam),
          ),
        ),

      ],
    ),
    );
  }
}
