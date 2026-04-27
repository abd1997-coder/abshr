import '../../domain/entities/address.dart';

class AddressModel {
  final String id;
  final String street;
  final String city;
  final String zipCode;
  final String phone;
  final double lat;
  final double lng;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.phone,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });

  factory AddressModel.fromMobileApiJson(Map<String, dynamic> json) {
    final latVal = json['lat'];
    final lngVal = json['lng'];
    double lat = 0;
    double lng = 0;
    if (latVal is num) {
      lat = latVal.toDouble();
    }
    if (lngVal is num) {
      lng = lngVal.toDouble();
    }

    return AddressModel(
      id: json['id']?.toString() ?? '',
      street:
          (json['address'] ?? json['address_1'] ?? json['street'] ?? '')
              .toString()
              .trim(),
      city: (json['city'] as String? ?? '').trim(),
      zipCode:
          (json['postal_code'] ?? json['zip_code'] ?? json['zipCode'] ?? '')
              .toString()
              .trim(),
      phone: (json['phone'] as String? ?? '').trim(),
      lat: lat,
      lng: lng,
      isDefault: json['is_default'] == true || json['isDefault'] == true,
    );
  }

  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      street: address.street,
      city: address.city,
      zipCode: address.zipCode,
      phone: address.phone,
      lat: address.lat,
      lng: address.lng,
      isDefault: address.isDefault,
    );
  }

  Address toEntity() {
    return Address(
      id: id,
      street: street,
      city: city,
      zipCode: zipCode,
      phone: phone,
      lat: lat,
      lng: lng,
      isDefault: isDefault,
    );
  }

  Map<String, dynamic> toMobileCreateOrUpdateBody() {
    return {
      'phone': phone,
      'address': street,
      'city': city,
      'lat': lat,
      'lng': lng,
    };
  }
}
