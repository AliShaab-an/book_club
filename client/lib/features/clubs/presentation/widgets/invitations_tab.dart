import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import 'empty_state.dart';

class InvitationsTab extends StatefulWidget {
  const InvitationsTab({super.key});

  @override
  State<InvitationsTab> createState() => _InvitationsTabState();
}

class _InvitationsTabState extends State<InvitationsTab> {
  // TODO: Replace with actual data from repository
  final List<ClubInvitation> _invitations = [];

  void _handleAccept(String invitationId) {
    // TODO: Call repository to accept invitation
    setState(() {
      _invitations.removeWhere((inv) => inv.id == invitationId);
    });
  }

  void _handleDecline(String invitationId) {
    // TODO: Call repository to decline invitation
    setState(() {
      _invitations.removeWhere((inv) => inv.id == invitationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_invitations.isEmpty) {
      return const EmptyState(
        icon: Icons.mail_outline,
        title: 'No Invitations',
        message: 'You don\'t have any club invitations at the moment.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _invitations.length,
      itemBuilder: (context, index) {
        final invitation = _invitations[index];
        return InvitationTile(
          invitation: invitation,
          onAccept: () => _handleAccept(invitation.id),
          onDecline: () => _handleDecline(invitation.id),
        );
      },
    );
  }
}

class ClubInvitation {
  final String id;
  final String clubName;
  final String bookTitle;
  final String inviterName;
  final DateTime sentAt;

  const ClubInvitation({
    required this.id,
    required this.clubName,
    required this.bookTitle,
    required this.inviterName,
    required this.sentAt,
  });
}

class InvitationTile extends StatelessWidget {
  final ClubInvitation invitation;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const InvitationTile({
    super.key,
    required this.invitation,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Pallete.whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Pallete.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              invitation.clubName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Pallete.blackColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Book: ${invitation.bookTitle}',
              style: const TextStyle(fontSize: 14, color: Pallete.greyColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Invited by ${invitation.inviterName}',
              style: const TextStyle(fontSize: 12, color: Pallete.greyColor),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Pallete.greyColor,
                    side: const BorderSide(color: Pallete.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Decline'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.greenColor,
                    foregroundColor: Pallete.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
