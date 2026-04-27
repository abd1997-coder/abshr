class Profile {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String bio;
  final String? avatarUrl;

  Profile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.bio,
    this.avatarUrl,
  });
}
