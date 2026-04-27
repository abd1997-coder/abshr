import 'package:equatable/equatable.dart';

class Seller extends Equatable {
  final String id;
  final String name;
  final String handle;
  final String description;
  /// Store logo / profile image (`photo` from API).
  final String imageUrl;
  final String coverPhotoUrl;
  final String city;
  final String addressLine;
  final String countryCode;
  final String phone;
  final String email;
  final int reviewCount;
  /// Display average, e.g. `4.5` or `—` when unknown.
  final String rating;

  const Seller({
    required this.id,
    required this.name,
    required this.handle,
    required this.description,
    required this.imageUrl,
    required this.coverPhotoUrl,
    required this.city,
    required this.addressLine,
    required this.countryCode,
    required this.phone,
    required this.email,
    required this.reviewCount,
    required this.rating,
  });

  String get locationLine {
    final c = city.trim();
    final a = addressLine.trim();
    if (c.isNotEmpty && a.isNotEmpty && c != a) {
      return '$c · $a';
    }
    if (c.isNotEmpty) return c;
    if (a.isNotEmpty) return a;
    return '';
  }

  String get handleLine => handle.trim().isNotEmpty ? '@$handle' : '';

  @override
  List<Object?> get props => [
    id,
    name,
    handle,
    description,
    imageUrl,
    coverPhotoUrl,
    city,
    addressLine,
    countryCode,
    phone,
    email,
    reviewCount,
    rating,
  ];
}
