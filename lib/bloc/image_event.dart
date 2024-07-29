import 'package:equatable/equatable.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class PickImage extends ImageEvent {}

class ClassifyImage extends ImageEvent {
  final String imagePath;

  const ClassifyImage(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}
