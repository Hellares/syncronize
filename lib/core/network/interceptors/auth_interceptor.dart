import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Agregar headers comunes
    options.headers['Content-Type'] = 'application/json';
    
    // Si tienes un token guardado, agregarlo aquí
    // final token = await SecureStorage.getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    
    super.onRequest(options, handler);
  }
}