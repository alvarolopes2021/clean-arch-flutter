import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'Should return an integer when the string represents an unsigned integet',
        () async {
      final str = '123';

      final result = inputConverter!.stringToUnsignedInteger(str);

      expect(result, Right(123));
    });

    test('Should return a failure when the string is not an integer', () async {
      const str = 'abc';

      final result = inputConverter!.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('Should return a failure when the string is a negative integet',
        () async {
      final str = '-123';

      final result = inputConverter!.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
