import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for rootBundle
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'disease_recommendations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  String _result = "Upload a leaf image to analyze";
  Interpreter? _interpreter;
  List<String> _labels = [];
  final int _inputSize = 224;
  bool _showRecommendationButton = false;
  String _currentPrediction = "";

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Load model with options
      final interpreterOptions = InterpreterOptions();

      _interpreter = await Interpreter.fromAsset(
        'assets/vegetable_disease_model.tflite',
        options: interpreterOptions,
      );

      // Alternative way to get input/output details
      final inputTensor = _interpreter?.getInputTensor(0);
      final outputTensor = _interpreter?.getOutputTensor(0);

      debugPrint('Model loaded successfully');
      debugPrint('Input shape: ${inputTensor?.shape}');
      debugPrint('Output shape: ${outputTensor?.shape}');

      // Load labels
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n').where((e) => e.trim().isNotEmpty).toList();

      debugPrint('Labels loaded: ${_labels.length} classes');

    } catch (e, stack) {
      debugPrint('Error loading model: $e');
      debugPrint('Stack trace: $stack');

      setState(() {
        _result = 'Failed to load model: ${e.toString()}';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _showRecommendationButton = false;
          _result = "Processing image...";
        });
        await _classifyImage(_image!);
      }
    } catch (e) {
      debugPrint("Image picker error: $e");
      setState(() {
        _result = "Failed to pick image: ${e.toString()}";
      });
    }
  }

  Future<void> _classifyImage(File imageFile) async {
    if (_interpreter == null) {
      setState(() {
        _result = "Model not loaded";
      });
      return;
    }

    try {
      var input = _preprocessImage(imageFile);
      debugPrint("Image preprocessing completed");

      if (!_isLeafImage(input)) {
        setState(() {
          _result = "This is not a leaf image. Please upload a leaf image.";
        });
        return;
      }

      var output = List<List<double>>.generate(
        1,
            (_) => List<double>.filled(_labels.length, 0.0),
      );

      debugPrint("Running inference...");
      _interpreter!.run(input, output);
      debugPrint("Inference completed");

      int highestIndex = output[0].indexWhere((e) => e == output[0].reduce((a, b) => a > b ? a : b));
      _currentPrediction = _labels[highestIndex].trim().replaceAll('"', '');
      debugPrint('Prediction: "$_currentPrediction"');
      debugPrint('Raw output: ${output[0]}');

      String displayName = DiseaseRecommendations.getCleanDiseaseName(_currentPrediction);

      setState(() {
        _result = "Prediction: $displayName";
        _showRecommendationButton = true;
      });

    } catch (e) {
      debugPrint("Classification error: $e");
      setState(() {
        _result = "Error processing image: ${e.toString()}";
        _showRecommendationButton = false;
      });
    }
  }

  void _showRecommendations() {
    if (_currentPrediction.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => DiseaseRecommendations.getRecommendationCard(_currentPrediction, context),
    );
  }

  bool _isLeafImage(List<List<List<List<double>>>> imageTensor) {
    int greenPixelCount = 0;
    int totalPixels = _inputSize * _inputSize;

    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        // Note: Channel order is BGR (0: Blue, 1: Green, 2: Red)
        double g = imageTensor[0][y][x][1] * 255; // Green channel
        double r = imageTensor[0][y][x][2] * 255; // Red channel
        double b = imageTensor[0][y][x][0] * 255; // Blue channel

        if (g > r && g > b && g > 80) {
          greenPixelCount++;
        }
      }
    }

    return (greenPixelCount / totalPixels) > 0.1;
  }

  List<List<List<List<double>>>> _preprocessImage(File imageFile) {
    try {
      Uint8List imageBytes = imageFile.readAsBytesSync();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception("Failed to decode image");
      }

      img.Image resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);
      debugPrint("Image resized to $_inputSize x $_inputSize");

      var input = List.generate(
        1,
            (_) => List.generate(
          _inputSize,
              (_) => List.generate(
            _inputSize,
                (_) => List.filled(3, 0.0),
          ),
        ),
      );

      // Convert to BGR format and normalize to [0,1] to match Colab preprocessing
      for (int y = 0; y < _inputSize; y++) {
        for (int x = 0; x < _inputSize; x++) {
          img.Pixel pixel = resizedImage.getPixel(x, y);
          input[0][y][x][0] = pixel.b / 255.0; // Blue channel (now first)
          input[0][y][x][1] = pixel.g / 255.0; // Green channel
          input[0][y][x][2] = pixel.r / 255.0; // Red channel (now last)
        }
      }

      debugPrint("First pixel values (BGR): ${input[0][0][0]}");
      return input;
    } catch (e) {
      debugPrint("Preprocessing error: $e");
      setState(() {
        _result = "Image processing error: ${e.toString()}";
      });
      return List.generate(
        1,
            (_) => List.generate(
          _inputSize,
              (_) => List.generate(
            _inputSize,
                (_) => List.filled(3, 0.0),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  void _handleMenuSelection(String value) {
    if (value == 'about') {
      _navigateToAboutUs();
    } else if (value == 'contact') {
      _navigateToContactUs();
    }
  }

  void _navigateToAboutUs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutUsScreen(),
      ),
    );
  }

  void _navigateToContactUs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactUsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegetable Disease Detection'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 1), // Fixed color opacity
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'about',
                  child: Text('About Us'),
                ),
                const PopupMenuItem(
                  value: 'contact',
                  child: Text('Contact Us'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        color: Colors.green[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                _image!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_showRecommendationButton)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: _showRecommendations,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('View Recommendations'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tomato Disease Detection App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "DEVELOPED BY KBWELL", // This is intentional (brand name)
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "This app helps farmers and gardeners detect diseases in tomato leaves using AI. Simply upload an image of a tomato leaf, and the app will analyze it to identify potential diseases.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            const Text(
              "Features:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              "- Disease detection using AI\n- Easy-to-use interface\n- Camera and gallery integration\n- Real-time results",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Contact Us",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              "If you have any questions or feedback, feel free to reach out to us:",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            Text(
              "Email: kbwell@gmail.com",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              "Phone: +251 901975431",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}