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
  late final FirestoreTravelerRemoteDataSource _travelerRemoteDataSource;
  late final TravelerRepositoryImpl _travelerRepository;
  late final FirestoreLeadRemoteDataSource _leadRemoteDataSource;
  late final LeadRepositoryImpl _leadRepository;
  final List<String> _logs = <String>[];

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _travelerRemoteDataSource = FirestoreTravelerRemoteDataSource(
      firestore: _firestore,
    );
    _travelerRepository = TravelerRepositoryImpl(
      remoteDataSource: _travelerRemoteDataSource,
    );
    _leadRemoteDataSource = FirestoreLeadRemoteDataSource(
      firestore: _firestore,
    );
    _leadRepository = LeadRepositoryImpl(
      remoteDataSource: _leadRemoteDataSource,
    );
  }

  Future<void> _createTraveler() async {
    final now = DateTime.now();
    final traveler = TravelerModel(
      id: '',
      travelerCode: now.millisecondsSinceEpoch.toString(),
      firstName: 'Test',
      lastName: now.toIso8601String(),
      displayName: 'Test User',
      createdAt: now,
      updatedAt: now,
    );

    await _travelerRepository.createTraveler(traveler);
    _addLog('Traveler Created');
  }

  Future<void> _createLead() async {
    final now = DateTime.now();
    final lead = LeadModel(
      id: '',
      leadCode: now.millisecondsSinceEpoch.toString(),
      clientId: '',
      leadOwnerId: '',
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
    final stopwatch = Stopwatch()..start();
    final travelers = await _travelerRepository.fetchTravelers();
    stopwatch.stop();

    _addLog('Travelers Count: ${travelers.length}');
    _addLog('Fetch Travelers completed in ${stopwatch.elapsedMilliseconds} ms');
  }

  Future<void> _fetchLeads() async {
    final stopwatch = Stopwatch()..start();
    final leads = await _leadRepository.fetchLeads();
    stopwatch.stop();

    _addLog('Leads Count: ${leads.length}');
    _addLog('Fetch Leads completed in ${stopwatch.elapsedMilliseconds} ms');
  }

  Future<void> _fetchDirectLeadCount() async {
    _addLog('--- Direct Firestore Lead Diagnostics ---');
    final stopwatch = Stopwatch()..start();
    final snapshot = await _firestore
        .collection('leads')
        .where('isArchived', isEqualTo: false)
        .limit(20)
        .get();
    stopwatch.stop();

    _addLog('Direct Lead Count: ${snapshot.docs.length}');
    _addLog(
      'Direct Lead Query completed in ${stopwatch.elapsedMilliseconds} ms',
    );
  }

  Future<void> _fetchDirectTravelerCount() async {
    _addLog('--- Direct Firestore Traveler Diagnostics ---');
    final stopwatch = Stopwatch()..start();
    final snapshot = await _firestore
        .collection('travelers')
        .where('isArchived', isEqualTo: false)
        .limit(20)
        .get();
    stopwatch.stop();

    _addLog('Direct Traveler Count: ${snapshot.docs.length}');
    _addLog(
      'Direct Traveler Query completed in ${stopwatch.elapsedMilliseconds} ms',
    );
  }

  void _checkFirebaseInit() {
    _addLog('--- Firebase Initialization Diagnostics ---');
    _addLog('Firebase app name: ${_firestore.app.name}');
  }

  Future<void> _archiveLastLead() async {
    _addLog('Archive button tapped');
    final stopwatch = Stopwatch()..start();

    try {
      final leads = await _leadRepository.fetchLeads();
      _addLog('Fetched leads count: ${leads.length}');

      if (leads.isEmpty) {
        stopwatch.stop();
        _addLog('No leads available to archive');
        _addLog(
          'Archive Last Lead completed in ${stopwatch.elapsedMilliseconds} ms',
        );
        return;
      }

      final lead = leads.last;
      _addLog('Archiving lead: ${lead.id}');
      await _leadRepository.archiveLead(lead.id);
      stopwatch.stop();
      _addLog('Last Lead Archived');
      _addLog(
        'Archive Last Lead completed in ${stopwatch.elapsedMilliseconds} ms',
      );
    } catch (error) {
      stopwatch.stop();
      _addLog('Archive failed: $error');
    }
  }

  void _addLog(String message) {
    debugPrint(message);
    setState(() {
      _logs.add(message);
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
              onPressed: _createTraveler,
              child: const Text('Create Traveler'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _createLead,
              child: const Text('Create Lead'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchTravelers,
              child: const Text('Fetch Travelers'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchLeads,
              child: const Text('Fetch Leads'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchDirectLeadCount,
              child: const Text('Direct Firestore Lead Count'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchDirectTravelerCount,
              child: const Text('Direct Firestore Traveler Count'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _checkFirebaseInit,
              child: const Text('Check Firebase Init'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _archiveLastLead,
              child: const Text('Archive Last Lead'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.black12,
                child: SingleChildScrollView(
                  child: Text(
                    _logs.isEmpty ? 'No logs yet' : _logs.join('\n'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
