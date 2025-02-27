import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_application_1/features/home_page/screens/location/location_service.dart';

class LocationForm extends StatefulWidget {
  const LocationForm({super.key});

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final TextEditingController locationController = TextEditingController();
  final OutletsService _outletsService = OutletsService();

  List<Map<String, String>> _outletDisplayList = [];
  List<Map<String, String>> filteredOutlets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOutlets();
  }

  Future<void> _fetchOutlets() async {
    final outlets = await _outletsService.fetchOutlets();
    if (mounted) {
      setState(() {
        _outletDisplayList = outlets;
        filteredOutlets = _outletDisplayList.take(5).toList();
        isLoading = false; 
      });
    }
  }

  void _filterOutlets(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOutlets = [];
      } else {
        filteredOutlets = _outletDisplayList.where((outlet) {
          final name = outlet['outletName'] ?? "";
          final address = outlet['outletAddress'] ?? "";
          final code = outlet['outletCode'] ?? "";
          return name.toLowerCase().contains(query.toLowerCase()) ||
              address.toLowerCase().contains(query.toLowerCase()) ||
              code.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            _buildLabel(),
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildOutletList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        tr('discover_outlets'),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return CupertinoSearchTextField(
      controller: locationController,
      onChanged: _filterOutlets,
      placeholder: tr('search_placeholder'),
      style: const TextStyle(fontSize: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    );
  }

  Widget _buildOutletList() {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator()); // ✅ Loading UI
    }

    return Expanded(
      child: CupertinoScrollbar(
        child: filteredOutlets.isNotEmpty
            ? ListView.builder(
                itemCount: filteredOutlets.length,
                itemBuilder: (context, index) =>
                    _buildOutletItem(filteredOutlets[index]),
              )
            : Center(
                child: Text(
                  tr('no_results'),
                  style: const TextStyle(
                      fontSize: 16, color: CupertinoColors.systemGrey),
                ),
              ),
      ),
    );
  }

  Widget _buildOutletItem(Map<String, String> outlet) {
    return CupertinoListTile(
      title: Text(
        outlet['outletName'] ?? "Unknown Name",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.label,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            outlet['outletAddress'] ?? "No Address",
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            outlet['outletCode'] ?? "N/A",
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.activeBlue,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
