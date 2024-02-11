part of 'number_trivia_bloc.dart';

class NumberTriviaState extends Equatable {
  const NumberTriviaState(List<dynamic> list);

  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {
  Empty(super.list);
}

class Loading extends NumberTriviaState {
  Loading(super.list);
}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({required this.trivia}) : super([trivia]);
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message}) : super([message]);
}
