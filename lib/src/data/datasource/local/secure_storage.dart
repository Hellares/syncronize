import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final Map<String, dynamic> _cache = {};
  static bool _cacheWarmedUp = false;
  
  // ✅ OPTIMIZACIÓN: Configuración más rápida del FlutterSecureStorage
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // ✅ Usar configuración más rápida
      sharedPreferencesName: 'syncronize_secure_prefs',
      preferencesKeyPrefix: 'sync_',
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ✅ CACHE OPTIMIZATION: Warm up cache en background
  Future<void> warmUpCache() async {
    if (_cacheWarmedUp) return;
    
    try {
      // Solo leer las keys más importantes para evitar latencia
      final importantKeys = ['user', 'settings', 'token'];
      
      if (kDebugMode) print('🔥 Warming up SecureStorage cache...');
      
      for (final key in importantKeys) {
        try {
          final value = await _storage.read(key: key);
          if (value != null) {
            _cache[key] = json.decode(value);
          }
        } catch (e) {
          // Ignorar errores individuales, continuar con otras keys
          if (kDebugMode) print('⚠️ Error reading key $key during warmup: $e');
        }
      }
      
      _cacheWarmedUp = true;
      if (kDebugMode) print('🔥 SecureStorage cache warmed up');
    } catch (e) {
      // Si hay error, continuar sin cache
      _cacheWarmedUp = false;
      if (kDebugMode) print('⚠️ SecureStorage warmup failed: $e');
    }
  }

  Future<void> save(String key, dynamic value) async {
    final jsonValue = json.encode(value);
    
    // Update cache immediately para lecturas futuras
    _cache[key] = value;
    
    try {
      // ✅ OPTIMIZACIÓN: Usar Future sin await para no bloquear
      if (kDebugMode) {
        final stopwatch = Stopwatch()..start();
        await _storage.write(key: key, value: jsonValue);
        stopwatch.stop();
        if (stopwatch.elapsedMilliseconds > 100) {
          print('🐌 SecureStorage write slow: ${stopwatch.elapsedMilliseconds}ms for key: $key');
        }
      } else {
        // En producción, guardar sin bloquear tanto
        await _storage.write(key: key, value: jsonValue);
      }
    } catch (e) {
      // Si falla el guardado, remover del cache
      _cache.remove(key);
      rethrow;
    }
  }

  // ✅ OPTIMIZACIÓN: Save sin bloquear (fire and forget para casos no críticos)
  Future<void> saveAsync(String key, dynamic value) async {
    final jsonValue = json.encode(value);
    
    // Update cache immediately
    _cache[key] = value;
    
    // Save to storage en background sin bloquear
    _storage.write(key: key, value: jsonValue).catchError((e) {
      if (kDebugMode) print('⚠️ Async save failed for $key: $e');
      // No remover del cache porque la operación fue async
    });
  }

  Future<dynamic> read(String key) async {
    // ✅ CACHE FIRST: Check cache primero
    if (_cacheWarmedUp && _cache.containsKey(key)) {
      if (kDebugMode) print('💾 Cache hit for key: $key');
      return _cache[key];
    }
    
    // If not in cache, read from storage
    try {
      if (kDebugMode) {
        final stopwatch = Stopwatch()..start();
        final value = await _storage.read(key: key);
        stopwatch.stop();
        if (stopwatch.elapsedMilliseconds > 50) {
          print('🐌 SecureStorage read slow: ${stopwatch.elapsedMilliseconds}ms for key: $key');
        }
        
        if (value == null) return null;
        
        final decoded = json.decode(value);
        
        // Update cache
        _cache[key] = decoded;
        print('💾 Cache miss, loaded key: $key');
        
        return decoded;
      } else {
        // Versión optimizada para producción
        final value = await _storage.read(key: key);
        if (value == null) return null;
        
        final decoded = json.decode(value);
        _cache[key] = decoded;
        
        return decoded;
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Error reading key $key: $e');
      return null;
    }
  }

  Future<bool> remove(String key) async {
    // Remove from cache first
    _cache.remove(key);
    
    try {
      // Remove from storage
      await _storage.delete(key: key);
      return true;
    } catch (e) {
      if (kDebugMode) print('⚠️ Error removing key $key: $e');
      return false;
    }
  }

  Future<bool> contains(String key) async {
    // Check cache first
    if (_cacheWarmedUp && _cache.containsKey(key)) {
      return true;
    }
    
    // Check storage
    try {
      final value = await _storage.containsKey(key: key);
      return value;
    } catch (e) {
      if (kDebugMode) print('⚠️ Error checking key $key: $e');
      return false;
    }
  }

  // ✅ UTILITY: Clear cache
  void clearCache() {
    _cache.clear();
    _cacheWarmedUp = false;
    if (kDebugMode) print('🧹 SecureStorage cache cleared');
  }

  // ✅ UTILITY: Clear all
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      clearCache();
      if (kDebugMode) print('🧹 SecureStorage completely cleared');
    } catch (e) {
      if (kDebugMode) print('⚠️ Error clearing all: $e');
    }
  }

  // ✅ DEBUG UTILITY: Get cache stats
  Map<String, dynamic> getCacheStats() {
    return {
      'cache_warmed_up': _cacheWarmedUp,
      'cached_keys_count': _cache.length,
      'cached_keys': _cache.keys.toList(),
    };
  }
}