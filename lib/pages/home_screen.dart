import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:max_walls/widgets/custom_button.dart';
import 'package:max_walls/widgets/image_full_screen.dart';
import 'package:max_walls/widgets/wallpaper_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  int pageNo = 1;
  List photos = [];

  void getWallpapers() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          'Authorization':
              'RfDzllYoRnuODodKPIk0a95NIjaeJDdfhr5mrd2qWHik1pCLwVIJUX1T'
        },
      );
      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        setState(() {
          photos = result['photos'];
          isLoading = false; // Stop loading indicator once data is fetched
        });
      } else {
        throw Exception('Failed to load wallpapers');
      }
    } catch (e) {
      print(e);
    }
  }

  void loadMoreImages() async {
    try {
      setState(() {
        isLoading = true;
      });
      pageNo++;
      String url = "https://api.pexels.com/v1/curated?per_page=80&page=$pageNo";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'RfDzllYoRnuODodKPIk0a95NIjaeJDdfhr5mrd2qWHik1pCLwVIJUX1T'
        },
      );
      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        setState(() {
          photos.addAll(result['photos']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load more wallpapers');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      persistentFooterButtons: [
        CustomButton(
          text: "Load more",
          onClick: () {
            loadMoreImages();
          },
        ),
      ],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Max Walls",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading && photos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ImageFullScreen(
                              imageTitle: photos[index]['alt'],
                              image: photos[index]['src']['portrait'],
                            );
                          },
                        ),
                      );
                    },
                    child: WallpaperCard(
                      url: photos[index]['src']['tiny'],
                    ),
                  ),
                );
              },
              itemCount: photos.length,
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
