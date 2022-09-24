class LoginRequest {
  final String device = "Desktop | Firefox";
  final String emailAddress;
  final String password;

  LoginRequest(this.emailAddress, this.password);

  Map<String, dynamic> toJson() {
    return {
      'device': device,
      'emailAddress': emailAddress,
      'password': password,
    };
  }
}
