class SignForm {
  final String name;
  final String userName;
  final String email;
  final String password;

  SignForm(this.name, this.userName, this.email, this.password);

  Map toJson() {
    return {
      "name": this.name,
      "userName": this.userName,
      "email": this.email,
      "password": this.password,
    };
  }
}
