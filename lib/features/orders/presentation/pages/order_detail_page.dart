import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_colors.dart';
import 'package:marketplace/l10n/app_localizations.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_line_item.dart';

String _translateOrderStatus(String status, AppLocalizations translations) {
  final s = status.toLowerCase();
  if (s == 'pending') return translations.orderStatusPending;
  if (s == 'processing' || s == 'process') return translations.orderStatusProcessing;
  if (s == 'completed' || s == 'complete') return translations.orderStatusCompleted;
  if (s == 'cancelled' || s == 'cancel') return translations.orderStatusCancelled;
  if (s == 'refunded' || s == 'refund') return translations.orderStatusRefunded;
  if (s == 'fulfilled') return translations.orderStatusFulfilled;
  if (s == 'archived') return translations.orderStatusArchived;
  return status;
}

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.order, required this.l10n});

  final Order order;
  final AppLocalizations l10n;

  Color _statusColor() {
    final s = order.status.toLowerCase();
    if (s.contains('cancel') || s.contains('refund')) {
      return Colors.red.shade700;
    }
    if (s.contains('complete') || s.contains('fulfill')) {
      return Colors.green.shade700;
    }
    if (s.contains('pending') || s.contains('process')) {
      return AppConstants.primaryColor;
    }
    return Colors.blueGrey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final statusColor = _statusColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            title: Text(
              l10n.orderDetailsTitle,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderCard(
                    order: order,
                    primary: primary,
                    statusColor: statusColor,
                    l10n: l10n,
                  ),
                  if (order.placedAt != null) ...[
                    const SizedBox(height: 12),
                    _InfoTile(
                      icon: Icons.schedule_rounded,
                      label: l10n.placedOn,
                      value: order.placedAt!,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    l10n.orderItemsSection,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (order.lineItems.isEmpty)
                    _EmptyLineItems(primary: primary, l10n: l10n)
                  else
                    ...order.lineItems.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _LineItemTile(line: line, l10n: l10n),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _SummaryCard(order: order, primary: primary, l10n: l10n),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.order,
    required this.primary,
    required this.statusColor,
    required this.l10n,
  });

  final Order order;
  final Color primary;
  final Color statusColor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            primary.withValues(alpha: 0.85),
            const Color(0xFFFF9A5C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.category,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _translateOrderStatus(order.status, l10n),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              order.orderId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              order.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 15,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackOpacity08,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineItemTile extends StatelessWidget {
  const _LineItemTile({required this.line, required this.l10n});

  final OrderLineItem line;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final thumb = line.thumbnailUrl;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackOpacity06,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child:
                    thumb != null && thumb.isNotEmpty
                        ? Image.network(
                          thumb,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => ColoredBox(
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.fastfood_rounded,
                                  color: Colors.grey.shade500,
                                  size: 32,
                                ),
                              ),
                        )
                        : ColoredBox(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.fastfood_rounded,
                            color: Colors.grey.shade500,
                            size: 32,
                          ),
                        ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      height: 1.25,
                    ),
                  ),
                  if (line.variantTitle != null &&
                      line.variantTitle!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      line.variantTitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '× ${line.quantity}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        line.linePrice,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLineItems extends StatelessWidget {
  const _EmptyLineItems({required this.primary, required this.l10n});

  final Color primary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory_2_outlined, color: primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.lineItemsUnavailable,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.order,
    required this.primary,
    required this.l10n,
  });

  final Order order;
  final Color primary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackOpacity08,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.orderSummary,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.lineItems.map((e) => e.title).join(' - '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.orderTotalLabel,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                order.price,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
