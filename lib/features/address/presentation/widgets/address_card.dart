import 'package:flutter/material.dart';
import '../../domain/entities/address.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
    super.key,
  });

  static const Color _iconTint = Colors.orange;

  @override
  Widget build(BuildContext context) {
    final lines =
        address.fullAddress.split('\n').map((s) => s.trim()).where(
          (s) => s.isNotEmpty,
        ).toList();
    final head = lines.isNotEmpty ? lines.first : '';
    final tail =
        lines.length > 1 ? lines.sublist(1).join('\n') : '';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _iconTint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.location_on,
                    color: _iconTint,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (head.isNotEmpty)
                        Text(
                          head,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (tail.isNotEmpty) ...[
                        if (head.isNotEmpty) const SizedBox(height: 8),
                        Text(
                          tail,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Icon(
                        Icons.edit,
                        color: Colors.orange.shade400,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onDelete,
                      child: Icon(
                        Icons.delete,
                        color: Colors.red.shade400,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onSetDefault,
                      child: Icon(
                        address.isDefault
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color:
                            address.isDefault
                                ? Colors.green
                                : Colors.grey.shade400,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
