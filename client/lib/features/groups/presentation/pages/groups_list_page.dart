import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/group_books/presentation/pages/group_books_page.dart';
import 'package:client/features/groups/presentation/providers/groups_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupsListPage extends ConsumerWidget {
  const GroupsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        backgroundColor: Pallete.greenColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGroupDialog(context, ref),
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No groups yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first book club group',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateGroupDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Group'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.greenColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(groupsListProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Pallete.greenColor,
                      child: Text(
                        group.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      group.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: group.description != null
                        ? Text(
                            group.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditGroupDialog(context, ref, group);
                        } else if (value == 'delete') {
                          _deleteGroup(context, ref, group.id);
                        }
                      },
                    ),
                    onTap: () {
                      // Navigate to group books page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupBooksPage(
                            groupId: group.id,
                            groupName: group.name,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading groups',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.invalidate(groupsListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                Fluttertoast.showToast(msg: 'Please enter a group name');
                return;
              }

              Navigator.pop(context);

              final repository = ref.read(groupsRepositoryProvider);
              final result = await repository.createGroup(
                name: nameController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
              );

              result.fold(
                (failure) {
                  Fluttertoast.showToast(
                    msg: failure.errMessage,
                    backgroundColor: Colors.red,
                  );
                },
                (group) {
                  Fluttertoast.showToast(
                    msg: 'Group created successfully!',
                    backgroundColor: Colors.green,
                  );
                  ref.invalidate(groupsListProvider);
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.greenColor,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, WidgetRef ref, group) {
    final nameController = TextEditingController(text: group.name);
    final descriptionController = TextEditingController(
      text: group.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                Fluttertoast.showToast(msg: 'Please enter a group name');
                return;
              }

              Navigator.pop(context);

              final repository = ref.read(groupsRepositoryProvider);
              final result = await repository.updateGroup(
                groupId: group.id,
                name: nameController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
              );

              result.fold(
                (failure) {
                  Fluttertoast.showToast(
                    msg: failure.errMessage,
                    backgroundColor: Colors.red,
                  );
                },
                (updatedGroup) {
                  Fluttertoast.showToast(
                    msg: 'Group updated successfully!',
                    backgroundColor: Colors.green,
                  );
                  ref.invalidate(groupsListProvider);
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.greenColor,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteGroup(BuildContext context, WidgetRef ref, String groupId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final repository = ref.read(groupsRepositoryProvider);
              final result = await repository.deleteGroup(groupId);

              result.fold(
                (failure) {
                  Fluttertoast.showToast(
                    msg: failure.errMessage,
                    backgroundColor: Colors.red,
                  );
                },
                (_) {
                  Fluttertoast.showToast(
                    msg: 'Group deleted successfully!',
                    backgroundColor: Colors.green,
                  );
                  ref.invalidate(groupsListProvider);
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
