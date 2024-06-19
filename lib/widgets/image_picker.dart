import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicker extends StatefulWidget {
  const ProfilePicker(this.radius, this.forwardImage, {super.key});
  final double radius;
  final void Function(File? image) forwardImage;

  @override
  State<ProfilePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ProfilePicker> {
  File? _image;

  void _pickImage() async {
    ImageSource imageSource = ImageSource.camera;
   final chosensource = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Take picher via?'),
        actions: [
          IconButton(
            onPressed: () {
              imageSource = ImageSource.camera;
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.camera_alt_rounded),
          ),
          IconButton(
            onPressed: () {
              imageSource = ImageSource.gallery;
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.photo_library),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceAround,
      ),
    );
    if(chosensource==null)return;

    final storedImage = await ImagePicker().pickImage(
        source: imageSource, preferredCameraDevice: CameraDevice.front,imageQuality: 30,);

    if (storedImage == null) return;
    setState(() {
      _image = File(storedImage.path);
    });
    widget.forwardImage(File(storedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
          backgroundImage: _image == null
              ? const AssetImage('assets/images/image.png') as ImageProvider
              : FileImage(_image!),
          radius: widget.radius / 4,
        ),
        const SizedBox(
          height: 2,
        ),
        InkWell(
            onTap: _pickImage,
            splashColor: Colors.amber.withOpacity(0),
            child: Icon(
              Icons.camera_alt,
              color: theme.colorScheme.primary,
              size: widget.radius / 4,
            ))
      ],
    );
  }
}
