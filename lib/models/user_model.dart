class UserModel {
  final String username;
  final String uid;
  final String password;
  final List<String> roles;

  UserModel({required this.username, required this.uid, required this.password, required this.roles});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json['username'], uid: json['uid'], password: json['password'], roles: List<String>.from(json['roles']));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'username': username, 'uid': uid, 'password': password, 'roles': roles};
}
