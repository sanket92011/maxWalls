import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:max_walls/widgets/custom_button.dart';

class ImageFullScreen extends StatefulWidget {
  const ImageFullScreen({
    super.key,
    required this.image,
    required this.imageTitle,
  });

  final String image;
  final String imageTitle;

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  Future<void> setWallpaper() async {
    try {
      final response = await http.get(Uri.parse(widget.image));

      if (response.statusCode == 200) {
        final Uint8List imageData = response.bodyBytes;

        var file = await DefaultCacheManager().getSingleFile(widget.image);
        int location = WallpaperManager.HOME_SCREEN;
        await WallpaperManager.setWallpaperFromFile(file.path, location);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wallpaper set successfully")),
        );
      } else {
        throw Exception("Failed to download image");
      }
    } catch (e) {
      print('Error setting wallpaper: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error setting wallpaper")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        CustomButton(
          text: "Set Wallpaper",
          onClick: () {
            setWallpaper();
          },
        )
      ],
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
