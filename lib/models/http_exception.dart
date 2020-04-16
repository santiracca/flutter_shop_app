class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  toString() {
    return message;
  }
}
