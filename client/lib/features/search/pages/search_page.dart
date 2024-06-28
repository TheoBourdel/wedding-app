import 'package:client/features/search/pages/service_item.dart';
import 'package:flutter/material.dart';
import 'package:client/model/service.dart';
import 'package:client/repository/service_repository.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ServiceRepository _serviceRepository = ServiceRepository();

  List<Service> _services = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchServices);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchServices);
    _searchController.dispose();
    super.dispose();
  }

  void _searchServices() async {
    final name = _searchController.text;
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a service name';
        _services = [];
      });
      return;
    }

    try {
      final services = await _serviceRepository.searchServicesByName(name);
      setState(() {
        _services = services;
        _errorMessage = services.isEmpty ? 'No services found' : null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load services: $e';
        _services = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter service name',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) => _searchServices(),
            ),
            const SizedBox(height: 30),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return ServiceListItem(service: service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
