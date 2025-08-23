part of 'entries_bloc.dart';

sealed class EntriesEvent extends Equatable {
  const EntriesEvent();

  @override
  List<Object> get props => [];
}

final class StoreEntry extends EntriesEvent {
  final Entry entry;

  const StoreEntry(this.entry);
}
