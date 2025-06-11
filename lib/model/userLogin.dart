class userLogin{
  final int account_id;
  final String name;
  final String email;
  final String role;

  userLogin({
    required this.account_id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory userLogin.fromJson(Map<String, dynamic> json) {
    return userLogin(
      account_id: json["id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "id": account_id,
      "name": name,
      "email": email,
      "role": role,
    };
  }
}