import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart'; // เพิ่ม

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  String _address = 'กำลังโหลดตำแหน่ง...';
  final TextEditingController _searchController = TextEditingController();
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyAo8zz60Yxv32lzFXlAZo99aaaGk-zFQcI'); // API Key

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
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _address = 'ไม่ได้รับสิทธิ์ในการเข้าถึงตำแหน่ง';
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    _currentLatLng = LatLng(position.latitude, position.longitude);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLatLng!, 16),
    );

    // แปลงตำแหน่งเป็นที่อยู่
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];
    setState(() {
      _address =
          '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
    });
  }

  Future<void> _searchPlace(String place) async {
  if (place.isEmpty) return;

  final response = await _places.searchByText(place);
  if (response.status == 'OK' && response.results.isNotEmpty) {
    final result = response.results.first;
    final latLng = LatLng(result.geometry!.location.lat, result.geometry!.location.lng);

    setState(() {
      _currentLatLng = latLng;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));

    // แปลงเป็นที่อยู่
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark placeMark = placemarks[0];
    setState(() {
      _address = '${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}';
    });
  } else {
    setState(() {
      _address = 'ไม่พบสถานที่';
    });
  }
}

  void _onMapTap(LatLng latLng) async {
    setState(() {
      _currentLatLng = latLng;
      _address = 'กำลังโหลดที่อยู่ใหม่...';
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    Placemark place = placemarks[0];
    setState(() {
      _address =
          '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกสถานที่สำหรับการจัดส่ง')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาสถานที่...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _searchPlace, // เมื่อผู้ใช้กด Enter
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  13.736717,
                  100.523186,
                ), // ตำแหน่งเริ่มต้น: กรุงเทพ
                zoom: 12,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: _onMapTap,
              markers:
                  _currentLatLng == null
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
                const Text(
                  'ที่อยู่ที่เลือก:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
