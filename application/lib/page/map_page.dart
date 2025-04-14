import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  String _address = 'กำลังโหลดตำแหน่ง...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ตรวจสอบว่าเปิด location หรือยัง
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _address = 'กรุณาเปิด Location Service';
      });
      return;
    }

    // ขอสิทธิ์การเข้าถึง location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _address = 'ไม่ได้รับอนุญาตให้เข้าถึงตำแหน่ง';
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        setState(() {
          _address = 'ไม่ได้รับสิทธิ์ในการเข้าถึงตำแหน่ง';
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    _currentLatLng = LatLng(position.latitude, position.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_currentLatLng!, 16));

    // แปลงตำแหน่งเป็นที่อยู่
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];
    setState(() {
      _address = '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
    });
  }

  void _onMapTap(LatLng latLng) async {
    setState(() {
      _currentLatLng = latLng;
      _address = 'กำลังโหลดที่อยู่ใหม่...';
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = placemarks[0];
    setState(() {
      _address = '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกตำแหน่งจัดส่ง')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.736717, 100.523186), // ตำแหน่งเริ่มต้น: กรุงเทพ
                zoom: 12,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: _onMapTap,
              markers: _currentLatLng == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _currentLatLng!,
                      ),
                    },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ที่อยู่ที่เลือก:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_address),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // ส่งตำแหน่งกลับหรือดำเนินการต่อ
                    Navigator.pop(context, _address);
                  },
                  child: const Text('ยืนยันตำแหน่งนี้'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
