import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:max_walls/widgets/custom_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageFullScreen extends StatefulWidget {
  const ImageFullScreen({
    super.key,
    required this.image,
    required this.photographer,
    required this.imageTitle,
    required this.photographerId,
  });

  final String image;
  final String photographer;
  final photographerId;
  final String imageTitle;

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  Future<void> saveImage() async {
    try {
      // Fetch the image bytes from the URL
      final response = await http.get(Uri.parse(widget.image));
      if (response.statusCode == 200) {
        // Convert image bytes to Uint8List
        Uint8List imageBytes = response.bodyBytes;

        // Save the image to the gallery using image_gallery_saver
        final result = await ImageGallerySaver.saveImage(
          imageBytes,
          quality: 80,
          name: widget.imageTitle.replaceAll(" ", "_"),
        );

        // Show success message
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(
              content: Text("Image saved to gallery"),
            ),
          );
        } else {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(
              content: Text("Failed to download image"),
            ),
          );
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      persistentFooterButtons: [
        CustomButton(
          text: "Download",
          onClick: () {
            saveImage();
          },
        )
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(100))),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: size.height * 0.7,
                  width: double.infinity,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadiusDirectional.all(Radius.circular(22))),
                    child: ClipRRect(
                      borderRadius: const BorderRadiusDirectional.all(
                        Radius.circular(10),
                      ),
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    scrollControlDisabledMaxHeightRatio: 0.3,
                    context: context,
                    builder: (context) {
                      return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  "Image Info",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Photographer :",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        widget.photographer,
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "PhotographerId :",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        widget.photographerId.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  widget.imageTitle,
                  style: const TextStyle(
                      fontSize: 16, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
