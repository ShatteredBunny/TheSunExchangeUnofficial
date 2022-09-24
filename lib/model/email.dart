class Email {
  final String emailAddress;

  Email({
    required this.emailAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'emailAddress': emailAddress,
    };
  }

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      emailAddress: json['emailAddress'] as String,
    );
  }
}
