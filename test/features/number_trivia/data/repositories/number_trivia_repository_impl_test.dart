import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/error/exceptions.dart';
import 'package:flutter_clean_arch/core/error/failures.dart';
import 'package:flutter_clean_arch/core/network/network_info.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetWorkInfo mockNetWorkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetWorkInfo = MockNetWorkInfo();

    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetWorkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetWorkInfo.isConnected)
            .thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetWorkInfo.isConnected)
            .thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('get concrete number trivia \n', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('* checks if device is online \n', () async {
      when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);

      repositoryImpl.getConcreteNumberTrivia(tNumber);

      verify(mockNetWorkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          '* should return remote data when call to remote data source is successful \n',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          '** should cache the data locally when the call to remote data source is successful \n',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          '* should return server failure when call to remote data source is unsuccessful \n',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        verifyZeroInteractions(mockLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });


    runTestsOffline(() {

      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('Should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });



  group('getRandomNumberTrivia \n', () {
    
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 123);

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('* checks if device is online \n', () async {
      when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);

      repositoryImpl.getRandomNumberTrivia();

      verify(mockNetWorkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          '* should return remote data when call to remote data source is successful \n',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          '** should cache the data locally when the call to remote data source is successful \n',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          '* should return server failure when call to remote data source is unsuccessful \n',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        verifyZeroInteractions(mockLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });


    runTestsOffline(() {

      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('Should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
