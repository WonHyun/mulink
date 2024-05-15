import 'package:flutter/material.dart';
import 'package:mulink/ui/common/mini_player/mini_player.dart';
import 'package:mulink/ui/home_screen/library_page/library_page.dart';
import 'package:mulink/ui/home_screen/library_page/playlist_page/playlist_page.dart';

enum Page {
  home,
  tracks,
  library,
  search,
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Page currentPage = Page.library;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => {},
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      switch (currentPage) {
                        case Page.home:
                          return const Column();
                        case Page.tracks:
                          return const PlaylistPage();
                        case Page.library:
                          return const LibraryPage();
                        case Page.search:
                          return const Column();
                        default:
                          return const Column();
                      }
                    },
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: MiniPlayer(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() {
            currentPage = Page.values.elementAt(index);
          }),
          currentIndex: currentPage.index,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_arrow), label: "Tracks"),
            BottomNavigationBarItem(
                icon: Icon(Icons.folder_open), label: "Library"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          ],
        ),
      ),
    );
  }
}
