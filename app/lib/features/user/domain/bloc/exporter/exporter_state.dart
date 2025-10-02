part of 'exporter_bloc.dart';

class ExporterState extends Equatable {
  const ExporterState();

  @override
  List<Object> get props => [];
}

class ExporterInitial extends ExporterState {}

class ExporterLoading extends ExporterState {}

class ExporterOperationSuccessful extends ExporterState {}

class ExporterOperationFailed extends ExporterState {
  final String errorMessage;
  final String stacktrace;

  const ExporterOperationFailed({
    required this.errorMessage,
    required this.stacktrace,
  });
}
