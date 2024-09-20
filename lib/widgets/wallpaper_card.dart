import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WallpaperCard extends StatefulWidget {
  const WallpaperCard({super.key, required this.url});

  final String url;

  @override
  State<WallpaperCard> createState() => _WallpaperCardState();
}

class _WallpaperCardState extends State<WallpaperCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadiusDirectional.all(Radius.circular(22)),
      child: CachedNetworkImage(
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        imageUrl: widget.url,
        fit: BoxFit.cover,
      ),
    );
  }
}
