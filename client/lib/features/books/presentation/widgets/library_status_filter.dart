import 'package:client/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum ReadingStatus { wantToRead, reading, finished }

class LibraryStatusFilter extends StatelessWidget {
  final ReadingStatus selectedStatus;
  final ValueChanged<ReadingStatus> onStatusChanged;

  const LibraryStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _FilterButton(
            label: 'Want to Read',
            isSelected: selectedStatus == ReadingStatus.wantToRead,
            onTap: () => onStatusChanged(ReadingStatus.wantToRead),
          ),
          _FilterButton(
            label: 'Reading',
            isSelected: selectedStatus == ReadingStatus.reading,
            onTap: () => onStatusChanged(ReadingStatus.reading),
          ),
          _FilterButton(
            label: 'Finished',
            isSelected: selectedStatus == ReadingStatus.finished,
            onTap: () => onStatusChanged(ReadingStatus.finished),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Pallete.greenColor : Pallete.transparentColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Pallete.whiteColor : Pallete.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
