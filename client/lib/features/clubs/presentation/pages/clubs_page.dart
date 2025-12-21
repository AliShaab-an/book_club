import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../widgets/my_clubs_tab.dart';
import '../widgets/discover_clubs_tab.dart';
import '../widgets/invitations_tab.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage>
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

  void _navigateToCreateClub() {
    // TODO: Navigate to CreateClubPage
    // Navigator.pushNamed(context, '/clubs/create');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
        title: const Text(
          'Clubs',
          style: TextStyle(
            color: Pallete.blackColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _navigateToCreateClub,
            icon: Icon(Icons.add_circle_outline, color: Pallete.greenColor),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Pallete.greenColor,
          unselectedLabelColor: Pallete.greyColor,
          indicatorColor: Pallete.greenColor,
          tabs: const [
            Tab(text: 'My Clubs'),
            Tab(text: 'Discover'),
            Tab(text: 'Invitations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [MyClubsTab(), DiscoverClubsTab(), InvitationsTab()],
      ),
    );
  }
}
