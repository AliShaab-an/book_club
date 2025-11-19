class Failure {
  final String errMessage;

  Failure([this.errMessage = 'Sorry, an unexpected error occurred!']);

  @override
  String toString() => 'message: $errMessage';
}
