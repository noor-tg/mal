import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal/constants.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onPickImage,
    this.existingImage,
  });

  final File? existingImage;
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 4,
            ),
          ),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                foregroundImage: widget.existingImage != null
                    ? FileImage(widget.existingImage!)
                    : _pickedImageFile != null
                    ? FileImage(_pickedImageFile!)
                    : const AssetImage(kAvatarPath),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: showPickerModal,
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    iconSize: 20,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 100,
      maxWidth: 150,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedImage == null) return;

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void showPickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              box16,
              Text(
                l10n.selectSource,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              box16,
              const Divider(height: 2),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    box16,
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          l10n.selectCamera,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    box16,
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          l10n.selectGallery,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
