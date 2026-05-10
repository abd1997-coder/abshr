import '../../domain/entities/user.dart';

class CustomerModel extends User {
  const CustomerModel({
    required String id,
    required String email,
    String? name,
    String? token,
    this.phone,
    this.firstName,
    this.lastName,
    this.hasAccount,
    this.createdAt,
  }) : super(id: id, email: email, name: name, token: token);

  final String? phone;
  final String? firstName;
  final String? lastName;
  final bool? hasAccount;
  final DateTime? createdAt;

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] as String?;
    final lastName = json['last_name'] as String?;
    String? name;
    if (firstName != null && lastName != null) {
      name = '$firstName $lastName'.trim();
    } else if (firstName != null) {
      name = firstName;
    } else if (lastName != null) {
      name = lastName;
    }

    return CustomerModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: name,
      phone: json['phone'] as String?,
      firstName: firstName,
      lastName: lastName,
      hasAccount: json['has_account'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'has_account': hasAccount,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}