import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class VinScannerScreen extends StatefulWidget {
  const VinScannerScreen({super.key});

  @override
  State<VinScannerScreen> createState() => _VinScannerScreenState();
}

class _VinScannerScreenState extends State<VinScannerScreen> {
  late CameraController _cameraController;
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _isProcessing = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController.initialize();
    if (!mounted) return;

    _cameraController.startImageStream(_processCameraImage);

    setState(() => _isCameraInitialized = true);
  }

  void _processCameraImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _isProcessing = false;
        return;
      }

      final recognizedText = await _textRecognizer.processImage(inputImage);

      final vinRegex = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$');
      String? foundVin;

      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          final cleanText = line.text.replaceAll(' ', '').toUpperCase();
          if (cleanText.length == 17 && vinRegex.hasMatch(cleanText)) {
            foundVin = cleanText;
            break;
          }
        }
        if (foundVin != null) break;
      }

      if (foundVin != null && mounted) {
        await _cameraController.stopImageStream();
        if (!mounted) return;
        Navigator.pop(context, foundVin);
      }
    } catch (e) {
      debugPrint("Ошибка распознавания: $e");
    } finally {
      _isProcessing = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (image.planes.isEmpty) return null;

    try {
      final plane = image.planes.first;
      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      );

      final bytes = _convertYUV420ToNV21(image);
      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      debugPrint("Ошибка конвертации кадра: $e");
      return null;
    }
  }

  Uint8List _convertYUV420ToNV21(CameraImage image) {
    final yPlane = image.planes[0].bytes;
    final uPlane = image.planes[1].bytes;
    final vPlane = image.planes[2].bytes;
    final yRowStride = image.planes[0].bytesPerRow;
    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerRow > 0 ? image.planes[1].bytesPerRow ~/ (image.width ~/ 2) : 1;
    final buffer = Uint8List(image.width * image.height * 3 ~/ 2);
    int pos = 0;

    for (int y = 0; y < image.height; y++) {
      buffer.setRange(pos, pos + image.width, yPlane, y * yRowStride);
      pos += image.width;
    }

    for (int y = 0; y < image.height ~/ 2; y++) {
      for (int x = 0; x < image.width ~/ 2; x++) {
        final uvIndex = uvPixelStride * x + uvRowStride * y;
        if (uvIndex < vPlane.length && uvIndex < uPlane.length) {
          buffer[pos++] = vPlane[uvIndex];
          buffer[pos++] = uPlane[uvIndex];
        }
      }
    }
    return buffer;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController),
          Center(
            child: Container(
              width: 300,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              "Наведите камеру на VIN в техпаспорте",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, backgroundColor: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _textRecognizer.close();
    super.dispose();
  }
}
