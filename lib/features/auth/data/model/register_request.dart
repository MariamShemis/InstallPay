class RegisterRequest {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });
}
