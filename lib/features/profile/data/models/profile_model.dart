import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.bio,
    super.avatarUrl,
  });

  /// `GET /store/mobile/profile` — supports flat or nested `customer` / `profile`.
  factory ProfileModel.fromMobileProfileJson(Map<String, dynamic> json) {
    final first = json['first_name'] as String? ?? '';
    final last = json['last_name'] as String? ?? '';
    final fromParts = [first, last]
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(' ');
    final fullName = fromParts.isNotEmpty
        ? fromParts
        : (json['full_name'] as String? ??
            json['fullName'] as String? ??
            'Guest');

    final email = json['email'] as String? ?? '';
    final phone = (json['phone'] as String?) ??
        (json['phone_number'] as String?) ??
        '';
    final bio = json['bio'] as String? ?? '';
    final avatarUrl =
        json['avatar_url'] as String? ?? json['avatarUrl'] as String?;

    return ProfileModel(
      fullName: fullName,
      email: email,
      phoneNumber: phone,
      bio: bio,
      avatarUrl: avatarUrl,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'] as String? ?? 'Guest',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  /// Body for `PUT /store/mobile/profile`.
  Map<String, dynamic> toMobileUpdateBody() {
    final parts = _splitFullName(fullName);
    return {
      'first_name': parts.first,
      'last_name': parts.last,
      'phone': phoneNumber,
    };
  }

  static ({String first, String last}) _splitFullName(String name) {
    final t = name.trim();
    if (t.isEmpty) return (first: '', last: '');
    final parts = t.split(RegExp(r'\s+'));
    if (parts.length == 1) return (first: parts[0], last: '');
    return (first: parts.first, last: parts.sublist(1).join(' '));
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }
}
