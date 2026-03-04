import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final bool isPasswordVisible;
  final int selectedYearIndex;
  final String? selectedFaculty;
  final RegisterStatus status;
  final String? errorMessage;

  const RegisterState({
    this.isPasswordVisible = false,
    this.selectedYearIndex = 0, // Default to First Year
    this.selectedFaculty,
    this.status = RegisterStatus.initial,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? isPasswordVisible,
    int? selectedYearIndex,
    String? selectedFaculty,
    RegisterStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      selectedYearIndex: selectedYearIndex ?? this.selectedYearIndex,
      selectedFaculty: selectedFaculty ?? this.selectedFaculty,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isPasswordVisible,
    selectedYearIndex,
    selectedFaculty,
    status,
    errorMessage,
  ];
}
