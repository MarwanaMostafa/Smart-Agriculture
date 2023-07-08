import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'dart:math' as math;

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen(this.cameras);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Timer _timer;
  int _imageCount = 0;
  List<dynamic> _resultsList = [];


  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _initializeCamera();
  }

  void _initializeCamera() async {
    try {
      await _controller.initialize();
      setState(() {});
      _startImageTimer();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startImageTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      _captureImage();
    });
  }

  void _captureImage() async {
    try {
      final directory = await getTemporaryDirectory();
      final pathImg =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      await _controller.takePicture(pathImg);
      final File savedImage = File(pathImg);

      if (savedImage == null) {
        print("No image selected");
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.10:5001/api/predictions'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        savedImage.path,
        contentType: MediaType(
          'image',
          path.extension(savedImage.path).substring(1),
        ),
      ));

      try {
        var response = await request.send();
        String responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          print('image uploaded successfully');

          List<dynamic> responseList = jsonDecode(responseBody);
          List<dynamic> results = [];


          for (int i = 1; i < responseList.length; i++) {
            List<dynamic> innerList = responseList[i];
            var className = innerList[0];
            var confidence = innerList[1];
            var x = innerList[2];
            var y = innerList[3];
            var w = innerList[4];
            var h = innerList[5];

            Map<String, dynamic> result = {
              "detectedClass": className,
              "confidenceInClass": confidence,
              "rect": {
                "x": x,
                "y": y,
                "w": w,
                "h": h,
              },
            };

            results.add(result);
            //print(results);
          }

          setState(() {
            _resultsList = results;
            print(_resultsList);
          });
        } else {
          print('Failed to upload image');
          print(responseBody);
        }
      } catch (e) {
        print('Failed to upload image $e');
      }

      print('Image $_imageCount saved: ${savedImage.path}');
      _imageCount++;
    } catch (e) {
      print('Error capturing image: $e');
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _stopImageTimer();
    super.dispose();
  }

  void _stopImageTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Analysis'),
      ),
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: CameraPreview(_controller),
            )
          else
            Center(child: CircularProgressIndicator()),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: BndBox(_resultsList),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.stop),
        onPressed: _stopImageTimer,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class BndBox extends StatelessWidget {
  final List<dynamic> results;

  BndBox(this.results);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: results.map((re) {
        var className = re["detectedClass"];
        var confidence = (re["confidenceInClass"] * 100).toStringAsFixed(0);

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Text(
            "$className: $confidence%",
            style: TextStyle(
              color: Colors.red,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }
}

