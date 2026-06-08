import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/payment_history_model.dart';

// Mock state for demonstration purposes
final mySubscriptionsProvider = StateNotifierProvider<MySubscriptionsNotifier, AsyncValue<PaymentHistoryResponse>>((ref) {
  return MySubscriptionsNotifier();
});

class MySubscriptionsNotifier extends StateNotifier<AsyncValue<PaymentHistoryResponse>> {
  MySubscriptionsNotifier() : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    // In a real implementation, this calls ApiService().getPaymentHistory()
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncValue.data(PaymentHistoryResponse(
      subscription: SubscriptionDetailsModel(
        status: 'ACTIVE',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 335)),
        isAutopayEnabled: true,
      ),
      history: [
        PaymentAttemptModel(
          id: '1',
          txnid: 'sub12345678',
          amount: '999.00',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          kind: 'MANDATE',
        ),
      ],
    ));
  }

  Future<void> cancelAutopay(BuildContext context) async {
    // In a real implementation, this calls ApiService().cancelAutopay()
    final currentState = state;
    if (currentState is AsyncData) {
      // Simulate API call
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) Navigator.pop(context); // close loading

      // Update local state
      state = AsyncValue.data(currentState.value!.copyWith(
        subscription: currentState.value!.subscription!.copyWith(
          isAutopayEnabled: false,
        ),
      ));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Autopay has been successfully cancelled.')),
        );
      }
    }
  }
}

class MySubscriptionsScreen extends ConsumerWidget {
  const MySubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mySubscriptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscriptions'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final sub = data.subscription;
          if (sub == null) {
            return const Center(child: Text('No active subscription found.'));
          }

          final DateFormat formatter = DateFormat('MMM dd, yyyy');

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Active Subscription Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current Subscription',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            label: Text(
                              sub.status,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: sub.status == 'ACTIVE' ? Colors.green : Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Started: ${formatter.format(sub.startDate)}'),
                      const SizedBox(height: 8),
                      Text(
                        'Valid Until: ${formatter.format(sub.endDate)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Autopay Control
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            sub.isAutopayEnabled ? Icons.autorenew : Icons.cancel_outlined,
                            color: sub.isAutopayEnabled ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Autopay',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            sub.isAutopayEnabled ? 'ON' : 'OFF',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: sub.isAutopayEnabled ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        sub.isAutopayEnabled
                            ? 'Your subscription will automatically renew on ${formatter.format(sub.endDate)}.'
                            : 'Autopay is disabled. You will need to manually renew your subscription when it expires.',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      if (sub.isAutopayEnabled) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            onPressed: () => _showCancelDialog(context, ref, formatter.format(sub.endDate)),
                            child: const Text('Stop Autopay'),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Payment History
              const Text(
                'Payment History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (data.history.isEmpty)
                const Text('No past payments found.')
              else
                ...data.history.map((attempt) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                      title: Text('₹${attempt.amount}'),
                      subtitle: Text(formatter.format(attempt.createdAt)),
                      trailing: Text(
                        attempt.kind == 'MANDATE' ? 'New Setup' : 'Renewal',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, String endDate) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Stop Autopay?'),
        content: Text(
          'Are you sure you want to stop autopay? You will have to manually renew your subscription after $endDate.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Autopay'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(mySubscriptionsProvider.notifier).cancelAutopay(context);
            },
            child: const Text('Stop Autopay'),
          ),
        ],
      ),
    );
  }
}
