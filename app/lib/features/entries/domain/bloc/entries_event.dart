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

final class EditEntry extends EntriesEvent {
  final Entry entry;

  const EditEntry(this.entry);
}

final class RemoveEntry extends EntriesEvent {
  final Entry entry;

  const RemoveEntry(this.entry);
}

final class LoadTodayEntries extends EntriesEvent {}
