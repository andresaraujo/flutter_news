class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  @override
  String toString() {
    return "Exception: $_message";
  }
}
