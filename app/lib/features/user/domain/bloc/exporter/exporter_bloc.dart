import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mal/features/user/data/services/exporter_service.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/utils/logger.dart';

part 'exporter_event.dart';
part 'exporter_state.dart';

class ExporterBloc extends Bloc<ExporterEvent, ExporterState> {
  ExporterBloc() : super(ExporterInitial()) {
    on<ExportToCsv>(_onExportToCsv);
  }

  FutureOr<void> _onExportToCsv(
    ExportToCsv event,
    Emitter<ExporterState> emit,
  ) async {
    try {
      emit(ExporterLoading());
      await ExporterService.exportEntriesToTsv(event.userUid, event.l10n);
      emit(ExporterOperationSuccessful());
      logger.i('csv exported successfully');
    } catch (e, t) {
      logger
        ..e(e)
        ..t(t);
      emit(
        ExporterOperationFailed(
          errorMessage: e.toString(),
          stacktrace: t.toString(),
        ),
      );
    }
  }
}
