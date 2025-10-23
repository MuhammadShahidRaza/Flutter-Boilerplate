/// Simple, reusable API result model
class ApiResult<T> {
  final T? data;
  final String? message;
  final bool success;

  const ApiResult({this.data, this.message, required this.success});
}
