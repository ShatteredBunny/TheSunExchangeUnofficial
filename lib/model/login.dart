class Login {
  final String login;

  Login({
    required this.login,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json['data'];
    return Login(
      login: data['login'] as String,
    );
  }
}
