import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/log_report_model.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import 'log_report_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  LoginCubit(this.authRepository) : super(LoginState());

  UserModel? currentUser;

  void togglePasswordVisibility() {
    emit(
      state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
        errorMessage: '',
        status: LoginStatus.initial,
      ),
    );
  }

  Future<void> login({required String phone, required String password}) async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: ''));
    Object result = "";
    try {
      result = await authRepository.loginWithDeviceId(
        phone: phone,
        password: password,
      );
      if (result is String) {
        emit(state.copyWith(status: LoginStatus.failure, errorMessage: result));
      } else if (result is UserModel) {
        currentUser = result;
        await lastLoginDateTime();
        emit(state.copyWith(status: LoginStatus.success, errorMessage: ''));
      }
    } catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    } finally {
      LogReportModel logReport = LogReportModel(
        name: currentUser!.name,
        email: currentUser!.email,
        phone: currentUser!.phone,
        faculty: currentUser!.faculty,
        studyYear: currentUser!.studyYear,
        type: currentUser!.role,
        isSuccess: result is String ? false : true,
        result: result is String
            ? "$result:${state.errorMessage}"
            : 'Login successful',
        dateTime: DateTime.now().toIso8601String(),
      );

      GetIt.I<LogReportCubit>().addLogReport(logReport);
    }
  }

  Future<void> refreshUserData() async {
    Object result = await authRepository.refreshUserData(
      userId: currentUser!.id,
    );

    if (result is String) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: result));
    } else if (result is UserModel) {
      currentUser = result;
      emit(state.copyWith(status: LoginStatus.success, errorMessage: ''));
    }
  }

  Future<void> lastLoginDateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLoginTime = prefs.getString('current_login_time');
    if (currentLoginTime != null) {
      await prefs.setString('last_login_time', currentLoginTime);
    }
    await prefs.setString(
      'current_login_time',
      DateTime.now().toIso8601String(),
    );
  }
}
