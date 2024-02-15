abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);

  @override
  String toString() {
    return 'ServerFailure{msg: ${super.message}';
  }
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);

  @override
  String toString() {
    return 'CacheFailure{msg: ${super.message}';
  }
}
