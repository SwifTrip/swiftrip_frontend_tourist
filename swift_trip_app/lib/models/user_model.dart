class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final int? companyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.companyId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Null safety and type checks for required fields
    if (json['id'] == null) {
      throw ArgumentError('UserModel.fromJson: "id" is required but was null');
    }
    if (json['firstName'] == null) {
      throw ArgumentError('UserModel.fromJson: "firstName" is required but was null');
    }
    if (json['lastName'] == null) {
      throw ArgumentError('UserModel.fromJson: "lastName" is required but was null');
    }
    if (json['email'] == null) {
      throw ArgumentError('UserModel.fromJson: "email" is required but was null');
    }
    if (json['role'] == null) {
      throw ArgumentError('UserModel.fromJson: "role" is required but was null');
    }
    if (json['createdAt'] == null) {
      throw ArgumentError('UserModel.fromJson: "createdAt" is required but was null');
    }
    if (json['updatedAt'] == null) {
      throw ArgumentError('UserModel.fromJson: "updatedAt" is required but was null');
    }
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? (throw ArgumentError('UserModel.fromJson: "id" is not a valid int')),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      companyId: json['companyId'] as int?,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : (throw ArgumentError('UserModel.fromJson: "createdAt" is not a valid String')),
      updatedAt: json['updatedAt'] is String
          ? DateTime.parse(json['updatedAt'])
          : (throw ArgumentError('UserModel.fromJson: "updatedAt" is not a valid String')),
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'companyId': companyId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Get full name
  String get fullName => '$firstName $lastName';
}
