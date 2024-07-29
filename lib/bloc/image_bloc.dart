import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    on<PickImage>((event, emit) async {
      try {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          emit(ImagePicked(pickedFile.path));
          add(ClassifyImage(pickedFile.path));
        } else {
          emit(const ImageError("No image selected"));
        }
      } catch (e) {
        emit(ImageError(e.toString()));
      }
    });
    on<ClassifyImage>((event, emit) async {
      try {
        final inputImage = InputImage.fromFilePath(event.imagePath);
        final imageLabeler = ImageLabeler(
            options: ImageLabelerOptions(confidenceThreshold: 0.5));
        final labels = await imageLabeler.processImage(inputImage);
        final classifications = labels.map((label) => label.label).toList();
        emit(ImageClassified(classifications));
      } catch (e) {
        emit(ImageError(e.toString()));
      }
    });
  }

  final ImagePicker _picker = ImagePicker();
}
