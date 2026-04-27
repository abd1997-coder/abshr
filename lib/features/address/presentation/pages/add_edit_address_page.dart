import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import '../../domain/entities/address.dart';

class AddEditAddressPage extends StatefulWidget {
  /// Existing address when editing; `null` when adding a new one.
  final Address? address;

  /// When adding ([address] is null), copy street/city/phone/zip and map pin
  /// from a previously saved address (e.g. default). Ignored when [address] is set.
  final Address? prefillTemplate;

  const AddEditAddressPage({
    this.address,
    this.prefillTemplate,
    super.key,
  });

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _phoneController;
  late TextEditingController _zipCodeController;
  late TextEditingController _apartmentController;
  GoogleMapController? _mapController;
  late LatLng _currentLocation;
  late Set<Marker> _markers = {};

  static const LatLng defaultLocation = LatLng(33.5138, 36.2765);

  void _refreshPreview() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final a = widget.address ?? widget.prefillTemplate;
    _streetController = TextEditingController(text: a?.street ?? '');
    _cityController = TextEditingController(text: a?.city ?? '');
    _phoneController = TextEditingController(text: a?.phone ?? '');
    _zipCodeController = TextEditingController(text: a?.zipCode ?? '');
    _apartmentController = TextEditingController();

    _streetController.addListener(_refreshPreview);
    _cityController.addListener(_refreshPreview);
    _zipCodeController.addListener(_refreshPreview);

    if (a != null && (a.lat != 0 || a.lng != 0)) {
      _currentLocation = LatLng(a.lat, a.lng);
    } else {
      _currentLocation = defaultLocation;
    }
    _markers = {
      Marker(
        markerId: const MarkerId('address_location'),
        position: _currentLocation,
        infoWindow: InfoWindow(title: AppStrings.selectedLocation),
      ),
    };
  }

  @override
  void dispose() {
    _streetController.removeListener(_refreshPreview);
    _cityController.removeListener(_refreshPreview);
    _zipCodeController.removeListener(_refreshPreview);
    _streetController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _zipCodeController.dispose();
    _apartmentController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _addMarker(LatLng location) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('address_location'),
          position: location,
          infoWindow: InfoWindow(title: AppStrings.selectedLocation),
        ),
      };
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _currentLocation = location;
      _addMarker(location);
    });
  }

  String get _previewText {
    final s = _streetController.text.trim();
    final c = _cityController.text.trim();
    final z = _zipCodeController.text.trim();
    final p = _phoneController.text.trim();
    if (s.isEmpty && c.isEmpty && p.isEmpty) {
      return AppStrings.pickLocationOnMap;
    }
    final parts = <String>[];
    if (s.isNotEmpty) {
      parts.add(s);
    }
    if (c.isNotEmpty) {
      parts.add(c);
    }
    if (z.isNotEmpty) {
      parts.add(z);
    }
    final line = parts.join(', ');
    if (p.isEmpty) {
      return line;
    }
    return line.isEmpty ? p : '$line\n$p';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation,
                      zoom: 15,
                    ),
                    markers: _markers,
                    onTap: _onMapTapped,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.address,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _previewText,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.streetBuildingLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _streetController,
                    decoration: InputDecoration(
                      hintText: AppStrings.hintStreetExample,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.cityUpper,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                hintText: AppStrings.hintCityDamascus,
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.phoneUpper,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: AppStrings.hintPhoneSyria,
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.postCodeOptionalUpper,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _zipCodeController,
                    decoration: InputDecoration(
                      hintText: AppStrings.optionalHint,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.apartmentOptionalUpper,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _apartmentController,
                    decoration: InputDecoration(
                      hintText: AppStrings.apartmentFloorHint,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final street = _streetController.text.trim();
                        final city = _cityController.text.trim();
                        final phone = _phoneController.text.trim();
                        if (street.isEmpty || city.isEmpty || phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppStrings.pleaseFillStreetCityPhone,
                              ),
                            ),
                          );
                          return;
                        }

                        final apt = _apartmentController.text.trim();
                        final addressLine =
                            apt.isEmpty ? street : '$street, $apt';

                        final newAddress = Address(
                          id: widget.address?.id ?? '',
                          street: addressLine,
                          city: city,
                          zipCode: _zipCodeController.text.trim(),
                          phone: phone,
                          lat: _currentLocation.latitude,
                          lng: _currentLocation.longitude,
                          isDefault: widget.address?.isDefault ?? false,
                        );

                        Navigator.pop(context, newAddress);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppStrings.saveLocation,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
