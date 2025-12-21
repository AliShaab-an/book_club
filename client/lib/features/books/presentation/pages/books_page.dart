import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/presentation/widgets/clubs_tab.dart';
import 'package:client/features/books/presentation/widgets/discover_tab.dart';
import 'package:client/features/books/presentation/widgets/my_library_tab.dart';
import 'package:flutter/material.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.backgroundColor,
        title: const Text(
          'Books',
          style: TextStyle(
            color: Pallete.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Pallete.greenColor,
          unselectedLabelColor: Pallete.subtitleText,
          indicatorColor: Pallete.greenColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'Discover'),
            Tab(text: 'My Library'),
            Tab(text: 'Clubs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [DiscoverTab(), MyLibraryTab(), ClubsTab()],
      ),
    );
  }
}
