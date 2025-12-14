import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/presentation/pages/books_search_page.dart';
import 'package:client/features/groups/presentation/pages/groups_list_page.dart';
import 'package:client/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to track the selected tab index
final selectedTabProvider = StateProvider<int>((ref) => 0);

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabProvider);

    // List of pages to display
    final List<Widget> pages = [
      const HomePage(),
      const GroupsListPage(),
      const BooksSearchPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedTabProvider.notifier).state = index;
        },
        selectedItemColor: Pallete.greenColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Books'),
        ],
      ),
    );
  }
}
