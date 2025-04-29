class CreateUserReq {
  final String fullName;
  final String email;
  final String password;
  final String? imageUrl;

  const CreateUserReq({
    required this.fullName,
    required this.email,
    required this.password,
    required this.imageUrl,
  });
}
