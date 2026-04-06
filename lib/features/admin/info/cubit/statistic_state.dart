part of 'statistic_cubit.dart';

sealed class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object> get props => [];
}

final class StatisticInitial extends StatisticState {}

final class StatisticLoading extends StatisticState {}

final class StatisticLoaded extends StatisticState {
  final int timestamp;
  StatisticLoaded({int? timestamp})
    : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [timestamp];
}
