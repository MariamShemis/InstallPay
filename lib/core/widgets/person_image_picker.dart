
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class PersonImagePicker extends StatefulWidget {
  final String? imageUrl;
  final ValueChanged<File?> onImageChanged;
  final double radius;

  const PersonImagePicker({
    super.key,
    this.imageUrl,
    required this.onImageChanged,
    this.radius = 48,
  });

  @override
  State<PersonImagePicker> createState() =>
      _PersonImagePickerState();
}

class _PersonImagePickerState extends State<PersonImagePicker> {
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (pickedFile == null || !mounted) return;

      final image = File(pickedFile.path);

      setState(() {
        _selectedImage = image;
      });

      widget.onImageChanged(image);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not select image. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });

    widget.onImageChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final avatarBackground = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;

    final iconColor = isDark
        ? ColorManager.darkAccentGreen1
        : ColorManager.green;

    ImageProvider? imageProvider;

    if (_selectedImage != null) {
      imageProvider = FileImage(_selectedImage!);
    } else if (widget.imageUrl != null &&
        widget.imageUrl!.trim().isNotEmpty) {
      imageProvider = NetworkImage(widget.imageUrl!);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: widget.radius.r,
                backgroundColor: avatarBackground,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(
                  Icons.person_outline_rounded,
                  size: (widget.radius * 0.9).r,
                  color: iconColor,
                )
                    : null,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: isDark
                    ? ColorManager.darkAccentGreen
                    : ColorManager.primaryColor,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _pickImage,
                  child: Padding(
                    padding: REdgeInsets.all(7),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: ColorManager.white,
                      size: 18.r,
                    ),
                  ),
                ),
              ),
            ),
            if (imageProvider != null)
              Positioned(
                top: -4.h,
                right: -4.w,
                child: Material(
                  color: Colors.red,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _removeImage,
                    child: Padding(
                      padding: REdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 15.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            if (_isPickingImage)
              Positioned.fill(
                child: CircleAvatar(
                  radius: widget.radius.r,
                  backgroundColor: Colors.black45,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          imageProvider == null ? 'Add Customer Photo' : 'Change Photo',
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
