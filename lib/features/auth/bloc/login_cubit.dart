import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
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

    try {
      Object result = await authRepository.loginWithDeviceId(
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
