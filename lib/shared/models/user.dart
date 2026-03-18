// lib/shared/models/user.dart

class User {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final String? photoUrl;
  final DateTime createdAt;
  final bool isVerified;
  final UserRole role;

  User({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    this.photoUrl,
    required this.createdAt,
    this.isVerified = false,
    this.role = UserRole.buyer,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      photoUrl: json['photo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      isVerified: json['is_verified'] as bool? ?? false,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.buyer,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'is_verified': isVerified,
      'role': role.toString().split('.').last,
    };
  }

  User copyWith({
    String? id,
    String? phone,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    bool? isVerified,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      role: role ?? this.role,
    );
  }
}

enum UserRole {
  buyer,
  seller,
  admin,
}
