part of 'exporter_bloc.dart';

sealed class ExporterEvent extends Equatable {
  const ExporterEvent();

  @override
  List<Object> get props => [];
}

final class ExportToCsv extends ExporterEvent {
  final String userUid;
  final AppLocalizations l10n;

  const ExportToCsv({required this.userUid, required this.l10n});
  @override
  List<Object> get props => [userUid, l10n];
}
