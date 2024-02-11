import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable{

  Failures( [List properties = const<dynamic>[]] );
}

// General failures
class ServerFailure extends Failures {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CacheFailure extends Failures {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}