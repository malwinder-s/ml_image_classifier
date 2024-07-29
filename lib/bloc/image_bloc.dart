import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial());

  final ImagePicker _picker = ImagePicker();

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is PickImage) {
      yield* _mapPickImageToState();
    } else if (event is ClassifyImage) {
      yield* _mapClassifyImageToState(event.imagePath);
    }
  }

  Stream<ImageState> _mapPickImageToState() async* {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        yield ImagePicked(pickedFile.path);
        add(ClassifyImage(pickedFile.path));
      } else {
        yield const ImageError("No image selected");
      }
    } catch (e) {
      yield ImageError(e.toString());
    }
  }

  Stream<ImageState> _mapClassifyImageToState(String imagePath) async* {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final ImageLabelerOptions options =
          ImageLabelerOptions(confidenceThreshold: 0.5);
      final imageLabeler = ImageLabeler(options: options);
      final labels = await imageLabeler.processImage(inputImage);
      final classifications = labels.map((label) => label.label).toList();
      yield ImageClassified(classifications);
    } catch (e) {
      yield ImageError(e.toString());
    }
  }
}
