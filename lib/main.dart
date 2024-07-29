import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/image_bloc.dart';
import 'bloc/image_event.dart';
import 'bloc/image_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => ImageBloc(),
        child: const ImageClassifierScreen(),
      ),
    );
  }
}

class ImageClassifierScreen extends StatelessWidget {
  const ImageClassifierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Classifier'),
      ),
      body: BlocConsumer<ImageBloc, ImageState>(
        listener: (context, state) {
          if (state is ImageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is ImageInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<ImageBloc>().add(PickImage()),
                child: const Text('Pick an Image'),
              ),
            );
          } else if (state is ImagePicked) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(File(state.imagePath)),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          } else if (state is ImageClassified) {
            return ClassificationResult(classifications: state.classifications);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class ClassificationResult extends StatelessWidget {
  final List<String> classifications;

  const ClassificationResult({super.key, required this.classifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: classifications.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: const Icon(Icons.label),
                  title: Text(
                    classifications[index],
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () => context.read<ImageBloc>().add(PickImage()),
          child: const Text('Pick New Image'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
