class RestApiExceptions implements Exception {
  final int? errorCode;
  final dynamic data;
  final dynamic d;
  RestApiExceptions(this.errorCode, {this.data, this.d});
}
