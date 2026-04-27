/// Address payload for `POST /store/mobile/checkout`.
class CheckoutShippingAddress {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String countryCode;
  final String postalCode;
  final String province;
  final String phone;
  final double? lat;
  final double? lng;

  const CheckoutShippingAddress({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.countryCode,
    required this.postalCode,
    required this.province,
    required this.phone,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address_1': address1,
      'city': city,
      'country_code': countryCode,
      'postal_code': postalCode,
      'province': province,
      'phone': phone,
      if (lat != null && lng != null)
        'metadata': {
          'lat': lat,
          'lng': lng,
        },
    };
  }
}
