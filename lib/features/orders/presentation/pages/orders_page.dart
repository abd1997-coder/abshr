import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/l10n/app_localizations.dart';
import '../cubit/orders_cubit.dart';
import '../../domain/entities/order.dart';
import '../widgets/order_card_domain.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final OrdersCubit _ordersCubit = getIt.get<OrdersCubit>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ordersCubit.loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = AppConstants.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.myOrders,
          style: const TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.more_horiz, color: Colors.black54),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              indicatorColor: primary,
              labelColor: primary,
              unselectedLabelColor: Colors.grey,
              tabs: [Tab(text: l10n.ongoing), Tab(text: l10n.history)],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<OrdersCubit, OrdersState>(
            bloc: _ordersCubit,
            builder: (context, state) {
              if (state is OrdersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrdersLoaded) {
                return _ordersListView(
                  primary,
                  _ordersForOngoing(state.orders),
                  false,
                  l10n,
                );
              } else if (state is OrdersError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<OrdersCubit, OrdersState>(
            bloc: _ordersCubit,
            builder: (context, state) {
              if (state is OrdersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrdersLoaded) {
                return _ordersListView(
                  primary,
                  _ordersForHistory(state.orders),
                  true,
                  l10n,
                );
              } else if (state is OrdersError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _ordersListView(Color primary, List<Order> orders, bool history, AppLocalizations l10n) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          history ? l10n.noPastOrdersYet : l10n.noActiveOrders,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children:
          orders.expand((o) {
            return [
              OrderCardDomain(item: o, primaryColor: primary, history: history, l10n: l10n),
              Divider(color: Colors.grey.shade300, thickness: 1, height: 12),
            ];
          }).toList(),
    );
  }

  static bool _isTerminalStatus(String status) {
    final s = status.toLowerCase();
    return s.contains('complete') ||
        s.contains('cancel') ||
        s.contains('refund') ||
        s.contains('archived');
  }

  List<Order> _ordersForOngoing(List<Order> all) {
    return all.where((o) => !_isTerminalStatus(o.status)).toList();
  }

  List<Order> _ordersForHistory(List<Order> all) {
    return all.where((o) => _isTerminalStatus(o.status)).toList();
  }
}