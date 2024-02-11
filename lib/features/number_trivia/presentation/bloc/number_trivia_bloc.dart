import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_arch/core/utils/input_converter.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/usecases/getConcreteNumberTrivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/usecases/getRandomNumberTrivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - the number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
    super.initialState, {
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(concrete != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random {
    on<NumberTriviaEvent>(mapEventToState);
  }

  NumberTriviaState get initialState => Empty([]);

  mapEventToState(
      NumberTriviaEvent event, Emitter<NumberTriviaState> emit) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      inputEither.fold((failure) {
        emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (integer) {
        throw UnimplementedError();
      });
    }
  }
}
