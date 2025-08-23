part of 'entries_bloc.dart';

enum EntriesStatus { initial, loading, success, failure }

class EntriesState extends Equatable {
  const EntriesState({
    this.currentEntry,
    this.status = EntriesStatus.initial,
    this.all = const [],
    this.errorMessage,
  });

  final EntriesStatus status;
  final Entry? currentEntry;
  final List<Entry> all;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, currentEntry, errorMessage, all];

  EntriesState copyWith({
    EntriesStatus? status,
    Entry? currentEntry,
    List<Entry>? all,
    String? errorMessage,
  }) {
    return EntriesState(
      status: status ?? this.status,
      currentEntry: currentEntry,
      errorMessage: errorMessage ?? this.errorMessage,
      all: all ?? this.all,
    );
  }
}
