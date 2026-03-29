class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'An error occurred connecting to the server.']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'An error occurred with local storage.']);
}
