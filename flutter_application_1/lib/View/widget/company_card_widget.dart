import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class CompaniesMapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> companies;
  
  final bool isFiltered;

  const CompaniesMapWidget({
    super.key, 
    required this.companies,
    this.isFiltered = false,
  });

  @override
  State<CompaniesMapWidget> createState() => _CompaniesMapWidgetState();
}

class _CompaniesMapWidgetState extends State<CompaniesMapWidget> {
  // NOUVEAU : La télécommande de la carte
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant CompaniesMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si on vient de cliquer sur une ligne dans la liste
    if (widget.isFiltered && widget.companies.isNotEmpty) {
      // On cherche les coordonnées du premier point valide
      final valid = widget.companies.firstWhere(
        (e) => e['latitude'] != null && e['longitude'] != null && 
               double.tryParse(e['latitude'].toString()) != null, 
        orElse: () => {}
      );
      
      if (valid.isNotEmpty) {
        final lat = double.parse(valid['latitude'].toString());
        final lng = double.parse(valid['longitude'].toString());
        
        // On déplace la caméra et on zoome (13.0 = niveau Ville)
        _mapController.move(LatLng(lat, lng), 13.0);
      }
    } 
    // Si on vient de désélectionner (on reclique sur la ligne pour annuler)
    else if (!widget.isFiltered && oldWidget.isFiltered) {
      // On dézoome et on retourne voir toute la France
      _mapController.move(const LatLng(45.777222, 3.087025), 6.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final validEntreprises = widget.companies.where((e) {
      return e['latitude'] != null &&
          e['longitude'] != null &&
          double.tryParse(e['latitude'].toString()) != null &&
          double.tryParse(e['longitude'].toString()) != null;
    }).toList();

    final markers = validEntreprises.map((e) {
      final lat = double.parse(e['latitude'].toString());
      final lng = double.parse(e['longitude'].toString());

      return Marker(
        width: 40,
        height: 40,
        point: LatLng(lat, lng),
        child: Tooltip(
          message: '${e['nom_entreprise']} (${e['nombre_alumni']} alumni)',
          child: const Icon(Icons.location_on, color: Colors.red, size: 30),
        ),
      );
    }).toList();

    final center = const LatLng(45.777222, 3.087025);

    return FlutterMap(
      mapController: _mapController, // <-- ON CONNECTE LA TÉLÉCOMMANDE ICI
      options: MapOptions(
        initialCenter: center,
        initialZoom: 6,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png',
          maxZoom: 20,
        ),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('© OpenStreetMap contributors © Stadia Maps')],
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 45,
            size: const Size(40, 40),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            maxZoom: 15,
            markers: markers,
            builder: (context, markers) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}