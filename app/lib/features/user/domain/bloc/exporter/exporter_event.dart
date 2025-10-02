part of 'exporter_bloc.dart';

sealed class ExporterEvent extends Equatable {
  const ExporterEvent();

  @override
  List<Object> get props => [];
}

final class ExportToCsv extends ExporterEvent {
  final String userUid;

  const ExportToCsv({required this.userUid});
}
