import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:kayraholidaymapscrm/core/constants/app_enums.dart';
import 'package:kayraholidaymapscrm/features/leads/data/datasources/firestore_lead_remote_data_source.dart';
import 'package:kayraholidaymapscrm/features/leads/data/repositories/lead_repository_impl.dart';
import 'package:kayraholidaymapscrm/features/leads/domain/models/lead_model.dart';
import 'package:kayraholidaymapscrm/features/travelers/data/datasources/firestore_traveler_remote_data_source.dart';
import 'package:kayraholidaymapscrm/features/travelers/data/repositories/traveler_repository_impl.dart';
import 'package:kayraholidaymapscrm/features/travelers/domain/models/traveler_model.dart';

class DevTestScreen extends StatefulWidget {
  const DevTestScreen({super.key});

  @override
  State<DevTestScreen> createState() => _DevTestScreenState();
}

class _DevTestScreenState extends State<DevTestScreen> {
  late final FirebaseFirestore _firestore;
  late final TravelerRepositoryImpl _travelerRepository;
  late final LeadRepositoryImpl _leadRepository;
  final List<String> _logs = <String>[];

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _travelerRepository = TravelerRepositoryImpl(
      remoteDataSource: FirestoreTravelerRemoteDataSource(
        firestore: _firestore,
      ),
    );
    _leadRepository = LeadRepositoryImpl(
      remoteDataSource: FirestoreLeadRemoteDataSource(
        firestore: _firestore,
      ),
    );
  }

  Future<void> _createDummyTraveler() async {
    final now = DateTime.now();
    final suffix = now.millisecondsSinceEpoch.toString();
    final traveler = TravelerModel(
      id: '',
      travelerCode: 'DEV-TRAV-$suffix',
      firstName: 'Test',
      lastName: suffix,
      displayName: 'Test User',
      createdAt: now,
      updatedAt: now,
    );

    await _travelerRepository.createTraveler(traveler);
    _addLog('Traveler Created');
  }

  Future<void> _createDummyLead() async {
    final now = DateTime.now();
    final suffix = now.millisecondsSinceEpoch.toString();
    final lead = LeadModel(
      id: '',
      leadCode: 'DEV-LEAD-$suffix',
      clientId: 'dev-client',
      leadOwnerId: 'dev-owner',
      destination: 'Dubai',
      travelType: TravelType.fit,
      tripScope: TripScope.international,
      leadStage: LeadStage.newLead,
      createdAt: now,
      updatedAt: now,
    );

    await _leadRepository.createLead(lead);
    _addLog('Lead Created');
  }

  Future<void> _fetchTravelers() async {
    final travelers = await _travelerRepository.fetchTravelers();
    _addLog('Fetched Travelers: ${travelers.length}');
  }

  Future<void> _fetchLeads() async {
    final leads = await _leadRepository.fetchLeads();
    _addLog('Fetched Leads: ${leads.length}');
  }

  Future<void> _archiveLastLead() async {
    final leads = await _leadRepository.fetchLeads();

    if (leads.isEmpty) {
      _addLog('No leads available to archive');
      return;
    }

    final lastLead = leads.last;
    await _leadRepository.archiveLead(lastLead.id);
    _addLog('Lead Archived');
  }

  Future<void> _runAction(Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stackTrace) {
      debugPrint('DEV TEST ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);
      _addLog('Error: $error');
    }
  }

  void _addLog(String message) {
    debugPrint(message);
    if (!mounted) {
      return;
    }

    setState(() {
      _logs.insert(0, '${DateTime.now().toIso8601String()} - $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DEV TEST')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _runAction(_createDummyTraveler),
              child: const Text('Create Dummy Traveler'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _runAction(_createDummyLead),
              child: const Text('Create Dummy Lead'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _runAction(_fetchTravelers),
              child: const Text('Fetch Travelers'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _runAction(_fetchLeads),
              child: const Text('Fetch Leads'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _runAction(_archiveLastLead),
              child: const Text('Archive Last Lead'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Logs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black12,
                child: _logs.isEmpty
                    ? const Text('No logs yet')
                    : ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(_logs[index]),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
