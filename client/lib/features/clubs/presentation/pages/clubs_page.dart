import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';
import '../widgets/my_clubs_tab.dart';
import '../widgets/discover_clubs_tab.dart';
import '../widgets/invitations_tab.dart';
import '../widgets/create_club_dialog.dart';
import '../providers/clubs_providers.dart';

class ClubsPage extends ConsumerStatefulWidget {
  const ClubsPage({super.key});

  @override
  ConsumerState<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends ConsumerState<ClubsPage>
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
    showDialog(
      context: context,
      builder: (dialogContext) => CreateClubDialog(
        onCreateClub: (name, description, book) {
          Navigator.of(dialogContext).pop();
          _handleCreateClub(name, description, book);
        },
      ),
    );
  }

  Future<void> _handleCreateClub(
    String name,
    String? description,
    Book book,
  ) async {
    try {
      print('DEBUG _handleCreateClub: Starting club creation UI flow');
      print(
        'DEBUG _handleCreateClub: Name: $name, BookID: ${book.id}, BookTitle: ${book.title}',
      );

      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Pallete.whiteColor,
                ),
              ),
              SizedBox(width: 12),
              Text('Creating club...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      print('DEBUG _handleCreateClub: Calling provider to create club...');

      // Create the club
      final club = await ref.read(
        createClubProvider({
          'name': name,
          'description': description ?? '',
          'bookId': book.id,
        }).future,
      );

      print('DEBUG _handleCreateClub: SUCCESS - Club created: ${club.id}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Club "$name" created successfully!'),
            backgroundColor: Pallete.greenColor,
          ),
        );

        print(
          'DEBUG _handleCreateClub: Invalidating myClubsProvider to refresh list',
        );
        // Refresh the clubs list
        ref.invalidate(myClubsProvider);
      }
    } catch (e) {
      print('DEBUG _handleCreateClub: ERROR - $e');
      print(
        'DEBUG _handleCreateClub: Error stack trace: ${StackTrace.current}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create club: ${e.toString()}'),
            backgroundColor: Pallete.errorColor,
          ),
        );
      }
    }
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
