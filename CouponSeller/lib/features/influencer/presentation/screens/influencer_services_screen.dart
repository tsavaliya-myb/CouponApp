import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/influencer_services_provider.dart';

class InfluencerServicesScreen extends ConsumerWidget {
  const InfluencerServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(influencerServicesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Services',
          style: AppTextStyles.headlineSM.copyWith(color: AppColors.primary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showServiceModal(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Service'),
      ),
      body: servicesAsync.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Text(
                'No services added yet.',
                style: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final s = services[index];
              return _buildServiceCard(context, ref, s);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, WidgetRef ref, Map<String, dynamic> service) {
    final isActive = service['status'] == 'ACTIVE';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(service['name'], style: AppTextStyles.titleLG),
              ),
              Switch(
                value: isActive,
                onChanged: (val) {
                  ref.read(influencerServicesProvider.notifier).toggleStatus(service['id']);
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (service['description'] != null)
            Text(
              service['description'],
              style: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '₹${service['price']}',
                style: AppTextStyles.headlineMD.copyWith(
                  decoration: service['discountedPrice'] != null ? TextDecoration.lineThrough : null,
                  color: service['discountedPrice'] != null ? AppColors.textSecondary : AppColors.primary,
                  fontSize: service['discountedPrice'] != null ? 16 : 24,
                ),
              ),
              if (service['discountedPrice'] != null) ...[
                const SizedBox(width: 8),
                Text(
                  '₹${service['discountedPrice']}',
                  style: AppTextStyles.headlineMD.copyWith(color: AppColors.primary),
                ),
              ],
              const Spacer(),
              Text('${service['deliveryDays']} days delivery', style: AppTextStyles.labelSM),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showServiceModal(context, ref, service: service),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () async {
                  final error = await ref.read(influencerServicesProvider.notifier).deleteService(service['id']);
                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                  }
                },
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showServiceModal(BuildContext context, WidgetRef ref, {Map<String, dynamic>? service}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ServiceFormModal(service: service, ref: ref),
    );
  }
}

class _ServiceFormModal extends StatefulWidget {
  final Map<String, dynamic>? service;
  final WidgetRef ref;
  const _ServiceFormModal({this.service, required this.ref});

  @override
  State<_ServiceFormModal> createState() => _ServiceFormModalState();
}

class _ServiceFormModalState extends State<_ServiceFormModal> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _deliveryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _nameController.text = widget.service!['name'];
      _descController.text = widget.service!['description'] ?? '';
      _priceController.text = widget.service!['price'].toString();
      _discountController.text = widget.service!['discountedPrice']?.toString() ?? '';
      _deliveryController.text = widget.service!['deliveryDays'].toString();
    }
  }

  Future<void> _submit() async {
    final data = {
      'name': _nameController.text.trim(),
      'description': _descController.text.trim(),
      'price': num.parse(_priceController.text.trim()),
      'discountedPrice': _discountController.text.trim().isNotEmpty ? num.parse(_discountController.text.trim()) : null,
      'deliveryDays': int.parse(_deliveryController.text.trim().isEmpty ? '3' : _deliveryController.text.trim()),
    };

    bool success;
    if (widget.service == null) {
      success = await widget.ref.read(influencerServicesProvider.notifier).createService(data);
    } else {
      success = await widget.ref.read(influencerServicesProvider.notifier).updateService(widget.service!['id'], data);
    }

    if (success && mounted) {
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save service')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.service == null ? 'Add Service' : 'Edit Service', style: AppTextStyles.titleLG),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Service Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price (₹)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Discounted (₹)', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deliveryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Delivery Days', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Service'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
