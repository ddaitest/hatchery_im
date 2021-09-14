import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class ImageDetailViewPage extends StatelessWidget {
  final ImageProvider? image;
  final File? imageFile;
  final String? imageUrl;

  ImageDetailViewPage({this.image, this.imageFile, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body:
          _photoView(imageInfo: image, file: imageFile, urlForImage: imageUrl),
    );
  }

  Widget _photoView(
      {ImageProvider? imageInfo, File? file, String? urlForImage}) {
    return Container(
        width: Flavors.sizesInfo.screenWidth,
        height: Flavors.sizesInfo.screenHeight,
        child: imageInfo == null && file == null
            ? PhotoView(
                imageProvider: CachedNetworkImageProvider(urlForImage!),
              )
            : imageInfo == null
                ? PhotoView(
                    imageProvider: FileImage(file!),
                  )
                : PhotoView(
                    imageProvider: imageInfo,
                  ));
  }
}
