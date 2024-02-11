import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/utils/input_converter.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/usecases/getConcreteNumberTrivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/usecases/getRandomNumberTrivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc? bloc;

  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;

  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;

  MockInputConverter? mockInputConverter;

  setUp(() async {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(Empty([]),
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter!);
  });

  test('initial state should be empty', () {
    expect(bloc!.initialState, equals(Empty([])));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';

    final tNumberParsed = 1;

    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      when(mockInputConverter!.stringToUnsignedInteger(tNumberString))
          .thenReturn(Right(tNumberParsed));

      bloc!.add(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(
          mockInputConverter!.stringToUnsignedInteger(tNumberString));

      verify(mockInputConverter!.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter!.stringToUnsignedInteger(tNumberString))
          .thenReturn(Left(InvalidInputFailure()));


      final expected = [
        Empty([]),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];

      expectLater(bloc!.state, emitsInOrder(expected));

      
      bloc!.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });
}
