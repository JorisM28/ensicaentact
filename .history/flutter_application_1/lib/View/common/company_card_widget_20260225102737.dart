import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CompaniesMapWidget extends StatelessWidget {
  final List<Map<String, dynamic>> companies;
  

  const CompaniesMapWidget({
    super.key,
    required this.companies,
  });

  @override
  Widget build(BuildContext context) {
    final validCompanies = companies.where((e) {
      return e['latitude'] != null &&
          e['longitude'] != null &&
          double.tryParse(e['latitude'].toString()) != null &&
          double.tryParse(e['longitude'].toString()) != null;
    }).toList();

    final markers = validCompanies.map((e) {
      final lat = double.parse(e['latitude'].toString());
      final lng = double.parse(e['longitude'].toString());

      return Marker(
        width: 40,
        height: 40,
        point: LatLng(lat, lng),
        child: Tooltip(
          message:
          '${e['nom_entreprise']} (${e['nombre_alumni']} alumni)',
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 30,
          ),
        ),
      );
    }).toList();

    final center =  const LatLng(45.777222, 3.087025);

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: validCompanies.isNotEmpty ? 6 : 3,
      ),
      children: [
        TileLayer(
          urlTemplate:
          'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png',
          maxZoom: 20,
        ),
        RichAttributionWidget(
          attributions: const [
            TextSourceAttribution(
                '© OpenStreetMap contributors © Stadia Maps'),
          ],
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}