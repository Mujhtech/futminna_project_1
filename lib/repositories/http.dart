import 'dart:convert';
import 'package:futminna_project_1/repositories/http_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

abstract class BaseHttpRepository {
  Future<Map<String, dynamic>> getRequest(
      Map<String, String> header, String url);
  Future<Map<String, dynamic>> postRequest(
      Map<String, String> header, Map<String, dynamic> body, String url);
  Future<Map<String, dynamic>> putRequest(
      Map<String, String> header, Map<String, dynamic> body, String url);
}

final httpRepositoryProvider =
    Provider<HttpRepository>((_) => HttpRepository());

class HttpRepository implements BaseHttpRepository {
  final client = http.Client();

  @override
  Future<Map<String, dynamic>> getRequest(
      Map<String, String> header, String url) async {
    Map<String, String> jsonHeader = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    final res =
        await client.get(Uri.parse(url), headers: {...jsonHeader, ...header});
    final data = json.decode(res.body);
    if (res.statusCode < 200 || res.statusCode > 210) {
      throw HTTPException(res.statusCode, "Something went wrong");
    }
    return data;
  }

  @override
  Future<Map<String, dynamic>> postRequest(Map<String, dynamic> header,
      Map<String, dynamic> body, String url) async {
    Map<String, String> jsonHeader = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    final res = await client.post(Uri.parse(url),
        headers: {...jsonHeader, ...header}, body: json.encode(body));
    final data = json.decode(res.body);
    if (res.statusCode < 200 || res.statusCode > 210) {
      throw HTTPException(res.statusCode, "Something went wrong");
    }
    return data;
  }

  @override
  Future<Map<String, dynamic>> putRequest(
      Map<String, String> header, Map<String, dynamic> body, String url) async {
    Map<String, String> jsonHeader = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    final res = await client.put(Uri.parse(url),
        headers: {...jsonHeader, ...header}, body: json.encode(body));
    final data = json.decode(res.body);
    if (res.statusCode < 200 || res.statusCode > 210) {
      throw HTTPException(res.statusCode, "Something went wrong");
    }
    return data;
  }
}
