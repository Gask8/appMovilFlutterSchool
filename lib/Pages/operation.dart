import 'dart:convert';
import 'dart:async';
import 'user.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('https://proyectofinalpdm.run-us-west2.goorm.io/getAll'));
  if (response.statusCode == 200) {
    return decodeUser(response.body);
  } else {
    throw Exception('Unable to fetch data from the REST API');
  }
}

List<User> decodeUser(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<User>((json) => User.fromMap(json)).toList();
}