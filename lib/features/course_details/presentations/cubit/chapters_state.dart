part of 'chapters_cubit.dart';

@immutable
sealed class ChaptersState {}

final class ChaptersInitial extends ChaptersState {}

final class ChaptersLoading extends ChaptersState {}

final class ChaptersLoaded extends ChaptersState {
	final List<Chapter> items;
	ChaptersLoaded({required this.items});
}

final class ChaptersListening extends ChaptersState {
	final List<Chapter> items;
	ChaptersListening({required this.items});
}

final class ChaptersOperationSuccess extends ChaptersState {
	final String message;
	ChaptersOperationSuccess({required this.message});
}

final class ChaptersFailure extends ChaptersState {
	final String error;
	ChaptersFailure({required this.error});
}
