import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/error/failures.dart';

class InputConverter {
  Either<Failures, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);

      if(integer < 0) {
        throw FormatException();
      }

      return Right(integer);

    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failures {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
