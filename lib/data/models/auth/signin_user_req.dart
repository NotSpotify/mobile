class SigninUserReq {
  String email;
  String password;

  SigninUserReq({required this.email, required this.password});

  // SigninUserReq.fromJson(Map<String, dynamic> json) {
  //   email = json['email'];
  //   password = json['password'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['email'] = email;
  //   data['password'] = password;
  //   return data;
  // }
}
