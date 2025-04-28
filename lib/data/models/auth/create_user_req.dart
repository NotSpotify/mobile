class CreateUserReq {
  final String fullName;
  final String email;
  final String password;


  const CreateUserReq({
    required this.fullName,
    required this.email,
    required this.password,
  });
}
