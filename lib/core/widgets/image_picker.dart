import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class ImagePickerBox extends StatefulWidget {
  final ValueChanged<XFile?>? onImagePicked;
  final String? initialImagePath;
  final String? title;
  final double? imageBoxWidth;
  final double? imageBoxHeight;
  final Color? borderColor;

  const ImagePickerBox({
    super.key,
    this.onImagePicked,
    this.initialImagePath,
    this.title,
    this.imageBoxWidth,
    this.imageBoxHeight,
    this.borderColor,
  });

  @override
  State<ImagePickerBox> createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() => _imageFile = file);
      widget.onImagePicked?.call(pickedFile);
    }
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimens.radiusM),
        ),
      ),
      builder: (_) {
        return AppBottomSheet(
          options: [
            AppBottomSheetOption(
              icon: Icons.photo_library,
              title: Common.pickFromGallery,
              onTap: () {
                context.pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            AppBottomSheetOption(
              icon: Icons.camera_alt,
              title: Common.pickFromCamera,
              onTap: () {
                context.pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
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
              color: widget.borderColor ?? AppColors.secondary,
              padding: EdgeInsets.all(Dimens.spacingXS),
            ),
            child: AppImage(
              path:
                  _imageFile?.path ?? widget.initialImagePath ?? AppAssets.user,
              width: widget.imageBoxWidth ?? 120,
              height: widget.imageBoxHeight ?? 120,
              fit: BoxFit.cover,
              borderRadius: Dimens.radiusM,
            ),
          ),
          AppText(
            widget.title ?? Common.uploadProfilePicture,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimens.spacingMSmall),
        ],
      ),
    );
  }
}
