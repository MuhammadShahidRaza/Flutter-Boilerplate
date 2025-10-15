import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sanam_laundry/core/constants/assets.dart';
import 'package:sanam_laundry/core/constants/strings.dart';
import 'package:sanam_laundry/core/utils/dimens.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/presentation/theme/colors.dart';

class ImagePickerBox extends StatefulWidget {
  const ImagePickerBox({super.key});

  @override
  State<ImagePickerBox> createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPickerOptions(context),
      child: Column(
        spacing: Dimens.spacingS,
        children: [
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(Dimens.radiusM),
              color: AppColors.secondary,
              padding: EdgeInsets.all(Dimens.spacingXS),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.radiusM),
              child: Container(
                height: 120,
                width: 120,
                color: AppColors.transparent,
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : AppImage(path: AppAssets.logo, isAsset: true),
              ),
            ),
          ),
          AppText(Common.uploadProfilePicture),
        ],
      ),
    );
  }
}
