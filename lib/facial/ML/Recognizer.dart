import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../DB/DatabaseHelper.dart';


class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 112;
  static const int HEIGHT = 112;
  final dbHelper = DatabaseHelper();
  Map<String, Recognition> registered = {};

  String get modelName => 'assets/mobile_face_net.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    initDB();
  }

  initDB() async {
    await dbHelper.init();
    loadRegisteredFaces();
  }

  void loadRegisteredFaces() async {
    final allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      String name = row[DatabaseHelper.columnName];
      List<double> embd = row[DatabaseHelper.columnEmbedding]
          .split(',')
          .map((e) => double.parse(e))
          .toList()
          .cast<double>();
      Recognition recognition = Recognition(
        name: row[DatabaseHelper.columnName],
        location: Rect.zero,
        embeddings: embd,
        distance: 0,
      );
      registered.putIfAbsent(name, () => recognition);
    }
  }

  void registerFaceInDB(String name, List<double> embedding) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnEmbedding: embedding.join(",")
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage =
        img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!
        .expand((channel) => [channel.r, channel.g, channel.b])
        .map((value) => value.toDouble())
        .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) / 127.5;
        }
      }
    }
    return reshapedArray.reshape([1, 112, 112, 3]);
  }

  Recognition recognize(img.Image image, Rect location) {
    var input = imageToArray(image);
    print(input.shape.toString());

    List output = List.filled(1 * 192, 0).reshape([1, 192]);

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('Time to run inference: $run ms$output');

    List<double> outputArray = output.first.cast<double>();

    Pair pair = findNearest(outputArray);
    print("distance= ${pair.distance}");

    return Recognition(
      name: pair.name,
      location: location,
      embeddings: outputArray,
      distance: pair.distance,
    );
  }

  Pair findNearest(List<double> emb) {
    Pair pair = Pair(name: "Unknown", distance: -5);
    for (MapEntry<String, Recognition> item in registered.entries) {
      final String name = item.key;
      List<double> knownEmb = item.value.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] - knownEmb[i];
        distance += diff * diff;
      }
      distance = sqrt(distance);
      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.name = name;
      }
    }
    return pair;
  }

  void close() {
    interpreter.close();
  }
}

class Pair {
  String name;
  double distance;
  Pair({required this.name, required this.distance});
}

class Recognition {
  String name;
  Rect location;
  List<double> embeddings;
  double distance;

  Recognition({
    required this.name,
    required this.location,
    required this.embeddings,
    required this.distance,
  });
}
