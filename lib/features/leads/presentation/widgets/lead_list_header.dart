import 'package:flutter/material.dart';

import '../../../../core/widgets/section_header.dart';

class LeadListHeader extends StatelessWidget {
  const LeadListHeader({
    required this.onCreateLead,
    super.key,
  });

  final VoidCallback onCreateLead;

  @override
  Widget build(BuildContext context) {
    return SectionHeader(
      title: 'Leads',
      subtitle: 'Manage and monitor all active lead inquiries',
      action: Align(
        alignment: Alignment.topRight,
        child: ElevatedButton(
          onPressed: onCreateLead,
          child: const Text('+ New Lead'),
        ),
      ),
    );
  }
}
