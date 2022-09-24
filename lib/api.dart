import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:the_sun_exchange_unofficial/model/login_request.dart';
import 'package:the_sun_exchange_unofficial/model/member_kyc_results.dart';
import 'package:the_sun_exchange_unofficial/model/member_wallet.dart';
import 'package:the_sun_exchange_unofficial/model/project.dart';
import 'package:the_sun_exchange_unofficial/model/query.dart';
import 'package:the_sun_exchange_unofficial/model/token.dart';
import 'model/dashboard.dart';
import 'model/email.dart';
import 'model/login.dart';
import 'model/member.dart';
import 'model/member_id.dart';

class Api {
  final Uri _url = Uri.https("service.thesunexchange.com", "graphql");
  final Map<String, String> postHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static final Api _instance = Api();
  String? _token;

  Future<Login> login(String email, String password) async {
    Query body = Query(
        "mutation (\$emailAddress: String!, \$password: String!, \$device: String!) { login(emailAddress: \$emailAddress, plaintextPassword: \$password, device: \$device)}",
        json.encode(LoginRequest(email, password).toJson()));
    Response res = await post(_url,
        headers: postHeaders, body: json.encode(body.toJson()));

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['errors'] == null) {
        var login = Login.fromJson(body);
        _token = login.login;
        return login;
      } else {
        throw body['errors'];
      }
    } else {
      throw "Error logging in, status code: ${res.statusCode}, body: ${res.body}";
    }
  }

  Future<Member> member({retry = true}) async {
    return Member.fromJson(await _post(
      "{ getMember { ...MemberFragment __typename }}fragment MemberFragment on Member { id emailAddress firstName lastName dob country city region address postalCode phoneNumber roles agreeToMarketing memberTwoFaSettings { googleTwoFAEnabled __typename } registrationState hasEarlyAccess vatReference __typename}",
    ));
  }

  Future<Dashboard> dashboard(int memberId, {retry = true}) async {
    return Dashboard.fromJson((await _post(
      "{ getDashboardData(memberId: $memberId) { ...DashboardDataFragment __typename }}fragment DashboardDataFragment on DashboardData { projects { urlSlug projectId projectDisplayName projectName projectStatus statusMessage projectStartDate campaignEndDate costOfCellsOwned cellsOwned cellsPending costOfCells { amount currency __typename } orderAmountPending { amount currency __typename } projectEarnings { rentalEarned currency __typename } numberOfBuyers numberOfDaysLeft numberOfCellsSold solarCellsAvailable progressPercent generatedKWhToDate rentalDistribution { beneficiaryName rentalPercentage __typename } totalKWhForecastForCells cellOwnerAgreementId __typename } totals { totalEarnedToDate outstandingBalance totalUnprocessedPayments totalEnergyGenerated totalGenerationCapacity totalPaid currency lastDistributionDate __typename } addresses { currency address __typename } __typename}",
    ))['data']['getDashboardData']);
  }

  Future<MemberKycResults> kycStatus(int memberId) async {
    return MemberKycResults.fromJson((await _post(
      "{ getMemberKycStatus(memberId: $memberId) { ...MemberKycDetailsFragment __typename }}fragment MemberKycDetailsFragment on MemberKycResults { status provider tierLevel kycCheckDate displayStatus displayProvider displayTierLevel requiredMemberAction canCashOut __typename}",
    ))['data']['getMemberKycStatus']);
  }

  Future<List<MemberWallet>> wallets(int memberId) async {
    return ((await _post(
      "mutation (\$memberId: Int!) { createWallets(memberId: \$memberId) { id memberId address currency balance __typename }}",
      payload: MemberId(memberId: memberId),
    ))['data']['createWallets'] as List)
        .map((e) => MemberWallet.fromJson(e))
        .toList();
  }

  Future<bool> authenticated() async {
    return (await _post("{authenticated}"))['data']['authenticated'] as bool;
  }

  Future<bool> logout(String? token) async {
    token ??= _token;
    if (token != null) {
      await _post("mutation (\$token: String!) {logout(token: \$token)}",
          payload: Token(token: token));
    }
    return true;
  }

  Future<List<Project>> projects() async {
    String query =
        "{ projects { ...ContProjectListItemFragment __typename }}fragment ContProjectListItemFragment on Project { urlSlug videoLink mainImage { ...AssetFragment __typename } brochure { ...AssetFragment __typename } summary featured __typename}fragment AssetFragment on UploadFile { url hash __typename}";
    Uri url = Uri.https("cms.thesunexchange.com", "graphql");
    Query body = Query(query, "{}");
    Response res = await post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body.toJson()));

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['errors'] == null) {
        return (body['data']['projects'] as List<dynamic>)
            .map((e) => Project.fromJson(e))
            .toList();
      } else {
        throw body['errors'];
      }
    } else {
      throw "Error logging in, status code: ${res.statusCode}, body: ${res.body}";
    }
  }

  Future<bool> passwordReset(String email) async {
    await _post(
        "mutation (\$emailAddress: String!) { sendPasswordResetEmail(emailAddress: \$emailAddress)}",
        payload: Email(emailAddress: email),
        token: false);
    return true;
  }

  Future<Map<String, dynamic>> _post(String query,
      {Object? payload, token = true, Uri? url, retry = true}) async {
    Query body = Query(query, payload ?? "{}");
    Response res = await post(url ?? _url,
        headers: token
            ? {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $_token',
              }
            : postHeaders,
        body: json.encode(body.toJson()));

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['errors'] == null) {
        return body;
      } else {
        if (retry) {
          const storage = FlutterSecureStorage();
          String? email = await storage.read(key: "email");
          String? password = await storage.read(key: "password");
          if (email != null && password != null) {
            await login(email, password);
            return await _post(query, payload: payload, retry: false, url: url);
          }
        }
        throw body['errors'];
      }
    } else {
      if (retry) {
        const storage = FlutterSecureStorage();
        String? email = await storage.read(key: "email");
        String? password = await storage.read(key: "password");
        if (email != null && password != null) {
          await login(email, password);
          return await _post(query, payload: payload, retry: false, url: url);
        }
      }
      throw "Error logging in, status code: ${res.statusCode}, body: ${res.body}";
    }
  }

  static Api get() {
    return _instance;
  }

  void setToken(String token) {
    _token = token;
  }
}
