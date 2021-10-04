class AuthForm {
  final String userName;
  final String password;

  AuthForm({required this.userName, required this.password});

  Map toJson() {
    return {
      "userName": this.userName,
      "password": this.password,
    };
  }
}
