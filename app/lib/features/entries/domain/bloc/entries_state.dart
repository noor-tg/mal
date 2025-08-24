part of 'entries_bloc.dart';

enum EntriesStatus { initial, loading, success, failure }

class EntriesState extends Equatable {
  const EntriesState({
    this.currentEntry,
    this.status = EntriesStatus.initial,
    this.today = const [],
    this.errorMessage,
  });

  final EntriesStatus status;
  final Entry? currentEntry;
  final List<Entry> today;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, currentEntry, errorMessage, today];

  EntriesState copyWith({
    EntriesStatus? status,
    Entry? currentEntry,
    List<Entry>? today,
    String? errorMessage,
  }) {
    return EntriesState(
      status: status ?? this.status,
      currentEntry: currentEntry,
      errorMessage: errorMessage ?? this.errorMessage,
      today: today ?? this.today,
    );
  }
}
