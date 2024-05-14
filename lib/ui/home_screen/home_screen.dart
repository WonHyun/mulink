import 'package:flutter/material.dart';
import 'package:mulink/ui/home_screen/library_page/library_page.dart';

enum Page {
  home,
  library,
  search,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Page currentPage = Page.library;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => setState(() {
            currentPage = Page.values.elementAt(index);
          }),
          currentIndex: currentPage.index,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.folder_open), label: "Library"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          ],
        ),
      ),
    );
  }
}
