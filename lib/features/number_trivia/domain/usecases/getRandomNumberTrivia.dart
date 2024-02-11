import 'package:equatable/equatable.dart';
import 'package:flutter_clean_arch/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/usecases/usecase.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

   @override
  Future<Either<Failures, NumberTrivia>?> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
