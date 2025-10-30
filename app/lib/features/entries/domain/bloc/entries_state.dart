part of 'entries_bloc.dart';

enum EntriesStatus { initial, loading, success, failure }

enum OperationType { create, update, remove }

class EntriesState extends Equatable {
  const EntriesState({
    this.operationType,
    this.status = EntriesStatus.initial,
    this.today = const [],
    this.currentCategory = const Result(list: [], count: 0),
    this.errorMessage,
  });

  final EntriesStatus status;
  final List<Entry> today;
  final Result<Entry> currentCategory;
  final String? errorMessage;
  final OperationType? operationType;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    today,
    operationType,
    currentCategory,
  ];

  EntriesState copyWith({
    EntriesStatus? status,
    List<Entry>? today,
    Result<Entry>? currentCategory,
    String? errorMessage,
    OperationType? operationType,
  }) {
    return EntriesState(
      status: status ?? this.status,
      operationType: operationType,
      errorMessage: errorMessage ?? this.errorMessage,
      today: today ?? this.today,
      currentCategory: currentCategory ?? this.currentCategory,
    );
  }
}
