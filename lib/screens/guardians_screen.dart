import 'package:flutter/material.dart';
import 'package:safegirl_pro/models/guardian.dart';
import 'package:safegirl_pro/services/app_services.dart';
import 'package:safegirl_pro/widgets/guardian_card.dart';
import 'package:safegirl_pro/theme.dart';

class GuardiansScreen extends StatefulWidget {
  const GuardiansScreen({super.key});

  @override
  State<GuardiansScreen> createState() => _GuardiansScreenState();
}

class _GuardiansScreenState extends State<GuardiansScreen> {
  final _services = AppServices();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final guardians = _services.guardian.getGuardians();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Guardians'),
        centerTitle: true,
      ),
      body: guardians.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No guardians added yet',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add up to 3 trusted contacts',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: guardians.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GuardianCard(
                  guardian: guardians[index],
                  onDelete: () => _deleteGuardian(guardians[index].id),
                  onEdit: () => _editGuardian(guardians[index]),
                ),
              ),
            ),
      floatingActionButton: guardians.length < 3
          ? FloatingActionButton.extended(
              onPressed: _addGuardian,
              icon: const Icon(Icons.add),
              label: const Text('Add Guardian'),
            )
          : null,
    );
  }

  Future<void> _addGuardian() async {
    final result = await showDialog<Guardian>(
      context: context,
      builder: (context) => const GuardianDialog(),
    );

    if (result != null) {
      await _services.guardian.addGuardian(result);
      setState(() {});
    }
  }

  Future<void> _editGuardian(Guardian guardian) async {
    final result = await showDialog<Guardian>(
      context: context,
      builder: (context) => GuardianDialog(guardian: guardian),
    );

    if (result != null) {
      await _services.guardian.updateGuardian(result);
      setState(() {});
    }
  }

  Future<void> _deleteGuardian(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Guardian'),
        content: const Text('Are you sure you want to remove this guardian?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _services.guardian.deleteGuardian(id);
      setState(() {});
    }
  }
}

class GuardianDialog extends StatefulWidget {
  final Guardian? guardian;

  const GuardianDialog({super.key, this.guardian});

  @override
  State<GuardianDialog> createState() => _GuardianDialogState();
}

class _GuardianDialogState extends State<GuardianDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  String _relationship = 'Family';
  int _priority = 1;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.guardian?.name);
    _phoneController = TextEditingController(text: widget.guardian?.phone);
    _emailController = TextEditingController(text: widget.guardian?.email);
    _relationship = widget.guardian?.relationship ?? 'Family';
    _priority = widget.guardian?.priority ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.guardian == null ? 'Add Guardian' : 'Edit Guardian'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(labelText: 'Email (Optional)'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _relationship,
                decoration: const InputDecoration(labelText: 'Relationship'),
                items: ['Family', 'Friend', 'Partner', 'Colleague']
                    .map(
                      (rel) => DropdownMenuItem(value: rel, child: Text(rel)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _relationship = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: [1, 2, 3]
                    .map(
                      (p) => DropdownMenuItem(
                          value: p, child: Text('Priority $p')),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ButtonStyle(
            foregroundColor:
                WidgetStateProperty.all(LightModeColors.lightSuccess),
          ),
          child: const Text(
            'Save',
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final guardian = Guardian(
      id: widget.guardian?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      name: _nameController.text,
      phone: _phoneController.text,
      relationship: _relationship,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      priority: _priority,
      createdAt: widget.guardian?.createdAt ?? now,
      updatedAt: now,
    );

    Navigator.pop(context, guardian);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
