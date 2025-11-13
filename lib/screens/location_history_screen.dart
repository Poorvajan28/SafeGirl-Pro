import 'package:flutter/material.dart';
import 'package:safegirl_pro/services/app_services.dart';
import 'package:intl/intl.dart';

class LocationHistoryScreen extends StatefulWidget {
  const LocationHistoryScreen({super.key});

  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  final _services = AppServices();
  List<Map<String, dynamic>> _locationHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocationHistory();
  }

  Future<void> _loadLocationHistory() async {
    setState(() => _isLoading = true);

    // Simulate loading location history
    // In real implementation, this would fetch from backend
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _locationHistory = [
        {
          'latitude': 28.6139,
          'longitude': 77.2090,
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'address': 'New Delhi, India',
          'accuracy': 15.0,
        },
        {
          'latitude': 28.6129,
          'longitude': 77.2295,
          'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
          'address': 'Connaught Place, Delhi',
          'accuracy': 12.0,
        },
        {
          'latitude': 28.5355,
          'longitude': 77.3910,
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'address': 'Noida, Uttar Pradesh',
          'accuracy': 20.0,
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.1),
              colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.location_history, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Location History',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : _locationHistory.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  size: 80,
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No location history',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your location tracking history will appear here',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadLocationHistory,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: _locationHistory.length,
                              itemBuilder: (context, index) {
                                final location = _locationHistory[index];
                                return _buildLocationCard(
                                    location, colorScheme, theme);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(
    Map<String, dynamic> location,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final timestamp = location['timestamp'] as DateTime;
    final formattedDate = DateFormat('MMM dd, yyyy').format(timestamp);
    final formattedTime = DateFormat('hh:mm a').format(timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Open in maps
            final lat = location['latitude'];
            final lng = location['longitude'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening location: $lat, $lng'),
                backgroundColor: colorScheme.primary,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location['address'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$formattedDate at $formattedTime',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.my_location,
                        label:
                            'Lat: ${location['latitude'].toStringAsFixed(4)}',
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.location_searching,
                        label:
                            'Lng: ${location['longitude'].toStringAsFixed(4)}',
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.gps_fixed,
                        label: '±${location['accuracy'].toStringAsFixed(0)}m',
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
