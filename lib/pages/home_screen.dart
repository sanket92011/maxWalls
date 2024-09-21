import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:max_walls/secrets.dart';
import 'package:max_walls/widgets/custom_button.dart';
import 'package:max_walls/widgets/custom_error.dart';
import 'package:max_walls/pages/image_full_screen.dart';
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
  String selectedFilter = "";
  List categories = [
    'Animals',
    'Nature',
    'Cars',
    'Buildings',
    'Food',
    'Space',
    'Abstract',
    'Technology',
    'Sports',
    'Travel',
    'Art',
    'Music',
    'Movies',
    'Fantasy',
    'Patterns',
    'Quotes',
    'Minimalist',
    'Vintage',
    'Flowers',
    'Underwater',
  ];
  TextEditingController searchController = TextEditingController();
  String selected = "";

  Future<void> getWallpapers({String? category}) async {
    try {
      setState(() {
        isLoading = true;
        if (category != null) {
          selectedFilter = category;
          photos.clear();
          pageNo = 1;
        }
      });

      String url = category != null
          ? "https://api.pexels.com/v1/search?query=$category&per_page=80&page=$pageNo"
          : "https://api.pexels.com/v1/curated?per_page=80";

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': ACCESS_KEY},
      );

      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        setState(() {
          photos = result['photos'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load wallpapers');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadFilteredImages() async {
    try {
      setState(() {
        isLoading = true;
      });
      pageNo++;
      String url =
          "https://api.pexels.com/v1/search?query=$selectedFilter&per_page=80&page=$pageNo";
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': ACCESS_KEY},
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      persistentFooterButtons: [
        CustomButton(
          text: "Load more",
          onClick: () {
            setState(() {
              loadFilteredImages();
            });
          },
        ),
      ],
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    useSafeArea: true,
                    scrollControlDisabledMaxHeightRatio: 0.7,
                    showDragHandle: true,
                    enableDrag: true,
                    context: context,
                    builder: (context) {
                      // Check if the keyboard is open
                      final bool isKeyboardOpen =
                          MediaQuery.of(context).viewInsets.bottom > 0;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: isKeyboardOpen
                                  ? MainAxisSize.max
                                  : MainAxisSize.min,
                              // Expand when keyboard is open
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Search here",
                                      prefixIcon: Icon(Icons.search)),
                                  controller: searchController,
                                ),
                                const Spacer(),
                                CustomButton(
                                  text: "Search",
                                  onClick: () {
                                    setState(() {
                                      final String searchText =
                                          searchController.text;
                                      getWallpapers(category: searchText);
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.search)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.square(10),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      String selectedCategory = categories[index].toString();
                      setState(() {
                        selected = selectedCategory;
                      });
                      getWallpapers(category: selectedCategory);
                    },
                    child: Chip(
                      backgroundColor: selected == categories[index]
                          ? const Color(0XFF2596be)
                          : Colors.black,
                      label: Text(
                        categories[index],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: categories.length,
            ),
          ),
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.black,
        title: const Text(
          "Max Walls",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : photos.isEmpty
              ? Center(
                  child: GestureDetector(
                    onTap: () {
                      getWallpapers();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Can't connect to internet"),
                        Center(child: CustomError(
                          onClick: () {
                            getWallpapers();
                          },
                        ))
                      ],
                    ),
                  ),
                )
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
                                  photographer: photos[index]['photographer'],
                                  photographerId: photos[index]
                                      ['photographer_id'],
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
