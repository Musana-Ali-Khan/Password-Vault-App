class VaultItemModel {
  final String id;
  final String platformName;
  final String email;
  final String password;
  final String additionalDetails;
  final String userId;

  VaultItemModel({
    required this.id,
    required this.platformName,
    required this.email,
    required this.password,
    required this.additionalDetails,
    required this.userId,
  });

  factory VaultItemModel.fromMap(Map<String, dynamic> map, String id) {
    return VaultItemModel(
      id: id,
      platformName: map['platformName'],
      email: map['email'],
      password: map['password'],
      additionalDetails: map['additionalDetails'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'platformName': platformName,
      'email': email,
      'password': password,
      'additionalDetails': additionalDetails,
      'userId': userId,
    };
  }
}
