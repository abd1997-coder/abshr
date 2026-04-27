import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  /// Maps to API field `address`.
  final String street;
  final String city;
  final String zipCode;
  final String phone;
  final double lat;
  final double lng;
  final bool isDefault;

  const Address({
    required this.id,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.phone,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });

  String get fullAddress {
    final zip = zipCode.trim().isNotEmpty ? ', $zipCode' : '';
    final phoneLine = phone.trim().isNotEmpty ? '\n$phone' : '';
    return '$street\n$city$zip$phoneLine';
  }

  @override
  List<Object?> get props => [
    id,
    street,
    city,
    zipCode,
    phone,
    lat,
    lng,
    isDefault,
  ];
}
