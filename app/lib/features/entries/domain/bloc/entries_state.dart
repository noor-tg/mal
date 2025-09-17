part of 'entries_bloc.dart';

enum EntriesStatus { initial, loading, success, failure }

enum OperationType { create, update, remove }

class EntriesState extends Equatable {
  const EntriesState({
    this.operationType,
    this.currentEntry,
    this.status = EntriesStatus.initial,
    this.today = const [],
    this.errorMessage,
  });

  final EntriesStatus status;
  final Entry? currentEntry;
  final List<Entry> today;
  final String? errorMessage;
  final OperationType? operationType;

  @override
  List<Object?> get props => [
    status,
    currentEntry,
    errorMessage,
    today,
    operationType,
  ];

  EntriesState copyWith({
    EntriesStatus? status,
    Entry? currentEntry,
    List<Entry>? today,
    String? errorMessage,
    OperationType? operationType,
  }) {
    return EntriesState(
      status: status ?? this.status,
      operationType: operationType,
      currentEntry: currentEntry,
      errorMessage: errorMessage ?? this.errorMessage,
      today: today ?? this.today,
    );
  }
}
