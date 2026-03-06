import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(AuthRepository authRepository) : super(const RegisterState());

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  // Select Academic Year
  void selectYear(int index) {
    emit(state.copyWith(selectedYearIndex: index));
  }

  // Submit Form
  Future<void> submitForm({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String faculty,
    required String studyYear,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      String result = await GetIt.I<AuthRepository>().register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        faculty: faculty,
        studyYear: studyYear,
      );
      if (result.startsWith('Error')) {
        emit(
          state.copyWith(status: RegisterStatus.failure, errorMessage: result),
        );
      } else {
        emit(state.copyWith(status: RegisterStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      String result = await GetIt.I<AuthRepository>().updateUser(userModel);
      if (result.startsWith('Error')) {
        emit(
          state.copyWith(status: RegisterStatus.failure, errorMessage: result),
        );
      } else {
        emit(state.copyWith(status: RegisterStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
