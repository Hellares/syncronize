import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> save(String key, dynamic value) async {
    await _storage.write(key: key, value: json.encode(value));
  }

  Future<dynamic> read(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return json.decode(value);
  }

  Future<bool> remove(String key) async {
    await _storage.delete(key: key);
    return true;
  }

  Future<bool> contains(String key) async {
    final value = await read(key);
    return value != null;
  }
}