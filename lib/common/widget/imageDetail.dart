import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class ImageDetailViewPage extends StatelessWidget {
  final ImageProvider? image;
  final File? imageFile;
  final String? imageUrl;

  ImageDetailViewPage({this.image, this.imageFile, this.imageUrl});

  late final PhotoView _photoView;

  _initPhotoView() {
    if (image == null && imageFile == null) {
      return CachedNetworkImageProvider(imageUrl!);
    } else if (image == null) {
      return FileImage(imageFile!);
    } else {
      return image;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initPhotoView();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          padding: const EdgeInsets.all(20.0),
          icon: Icon(
            Icons.arrow_back,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: _photoContainerView(),
    );
  }

  Widget _photoContainerView() {
    return Container(
        width: Flavors.sizesInfo.screenWidth,
        height: Flavors.sizesInfo.screenHeight,
        child: _photoView);
  }
}
