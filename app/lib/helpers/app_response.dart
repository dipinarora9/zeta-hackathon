class AppResponse<T> {
  final T? data;
  final String? error;

  AppResponse({this.data, this.error});

  bool isSuccess() => this.data != null;
}
