import 'dart:convert';

import 'package:flutter_clean_arch/core/error/exceptions.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTriva', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'Should return NumberTrivai from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('Should throw a CacheException when there is not a cached value',
        () async {
      when(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
    test('should call SharedPreferences to cache the data', () async {
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
