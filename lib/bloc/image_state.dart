import 'package:equatable/equatable.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImagePicked extends ImageState {
  final String imagePath;

  const ImagePicked(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ImageClassified extends ImageState {
  final List<String> classifications;

  const ImageClassified(this.classifications);

  @override
  List<Object> get props => [classifications];
}

class ImageError extends ImageState {
  final String error;

  const ImageError(this.error);

  @override
  List<Object> get props => [error];
}
