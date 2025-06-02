import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WebMapWidget extends StatefulWidget {
  final LatLng? selectedLatLng;
  final void Function(LatLng latLng) onTap;

  const WebMapWidget({
    super.key,
    required this.selectedLatLng,
    required this.onTap,
  });

  @override
  State<WebMapWidget> createState() => _WebMapWidgetState();
}

class _WebMapWidgetState extends State<WebMapWidget> {
  final MapController _mapController = MapController();
  final LatLng _defaultLatLng = LatLng(-7.797068, 110.370529);

  @override
  void didUpdateWidget(covariant WebMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLatLng != null &&
        widget.selectedLatLng != oldWidget.selectedLatLng) {
      _mapController.move(widget.selectedLatLng!, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = widget.selectedLatLng ?? _defaultLatLng;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 15,
        onTap: (tapPosition, point) => widget.onTap(point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.app',
        ),
        if (widget.selectedLatLng != null)
          MarkerLayer(
            markers: [
              Marker(
                point: widget.selectedLatLng!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
