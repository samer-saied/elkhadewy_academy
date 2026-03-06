part of 'watching_report_cubit.dart';

sealed class WatchingReportState extends Equatable {
  const WatchingReportState();

  @override
  List<Object> get props => [];
}

final class WatchingReportInitial extends WatchingReportState {}

final class WatchingReportLoading extends WatchingReportState {}

final class WatchingReportLoaded extends WatchingReportState {
  final List<WatchingReport> reports;

  const WatchingReportLoaded({required this.reports});

  @override
  List<Object> get props => [reports];
}

final class WatchingReportError extends WatchingReportState {
  final String message;

  const WatchingReportError({required this.message});

  @override
  List<Object> get props => [message];
}
