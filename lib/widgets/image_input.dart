import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onCapturePicture});

  final void Function(String file) onCapturePicture;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  String? _selectedImage;

  void _takePicture() async {
    final ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (image != null) {
      setState(() {
        _selectedImage = image.path;
      });

      widget.onCapturePicture(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      label: const Text("Take Picture"),
      icon: Icon(Icons.camera),
    );

    if (_selectedImage != null) {
      final ImageProvider imageProvider =
          kIsWeb
              ? NetworkImage(_selectedImage!)
              : FileImage(File(_selectedImage!));

      final image = Image(
        image: imageProvider,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );

      content = GestureDetector(onTap: _takePicture, child: image);
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: content,
    );
  }
}
