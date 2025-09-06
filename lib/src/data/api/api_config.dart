class ApiConfig{
  static const String localApi = "192.168.100.3:3000";
  static const String productionApi = 'api-gateway.syncronize.net.pe';
  
  static bool isProduction = false;

  static String get apiSyncronize => isProduction ? productionApi : localApi;

  static Uri getUri(String path){
    return isProduction
      ? Uri.https(apiSyncronize,path)
      : Uri.http(apiSyncronize, path);
  }
}