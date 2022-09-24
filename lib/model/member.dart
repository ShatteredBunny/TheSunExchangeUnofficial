class Member {
  final int id;
  final String emailAddress;
  final String firstName;
  final String lastName;
  final String? dob;
  final String? country;
  final String? city;
  final String? region;
  final String? address;
  final String? postalCode;
  final String? phoneNumber;
  final List<String> roles;
  final bool agreeToMarketing;
  // TODO: memberTwoFaSettings
  final String registrationState;
  final bool hasEarlyAccess;
  // TODO: vatReference

  Member({
    required this.id,
    required this.emailAddress,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.country,
    required this.city,
    required this.region,
    required this.address,
    required this.postalCode,
    required this.phoneNumber,
    required this.roles,
    required this.agreeToMarketing,
    required this.registrationState,
    required this.hasEarlyAccess,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> member = json['data']['getMember'];

    final List<String> roles =
        (member['roles'] as List).map((e) => e.toString()).toList();

    return Member(
      id: member['id'],
      emailAddress: member['emailAddress'],
      firstName: member['firstName'],
      lastName: member['lastName'],
      dob: member['dob'],
      country: member['country'],
      city: member['city'],
      region: member['region'],
      address: member['address'],
      postalCode: member['postalCode'],
      phoneNumber: member['phoneNumber'],
      roles: roles,
      agreeToMarketing: member['agreeToMarketing'],
      registrationState: member['registrationState'],
      hasEarlyAccess: member['hasEarlyAccess'],
    );
  }
}
