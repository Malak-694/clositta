import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';
import 'package:chicora/features/auth/data/repo/auth_repo.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;
  final prefs = getIt<SharedPrefHelper>();

  AuthCubit(this.repo) : super(AuthState.initial());

  Future<void> signUp(
    String username,
    String email,
    String password,
    String confirmPassword,
    String phone,

    String role,
  ) async {
    emit(const AuthState.loading());
    String rolefinal;
    switch (role) {
      case 'Customer':
        rolefinal = 'customer';
        break;
      case 'Tailor':
        rolefinal = 'tailor';
        break;
      case 'Admin':
        rolefinal = 'admin';
        break;
      case 'Clothes Seller':
        rolefinal = 'clothes_seller';
        break;
      case 'Material Seller':
        rolefinal = 'material_seller';
        break;
      default:
        rolefinal = 'customer';
        break;
    }
    try {
      final request = SignUpRequest(
        name: username,
        email: email,
        password: password,
        confirmpassword: confirmPassword,
        phone: phone,
        role: rolefinal,
      );

      final ApiResult<SignUpResponse> result = await repo.signUp(request);
      result.when(
        success: (SignUpResponse response) async {
          emit(AuthState.success("${response.message} , You can now log in."));
        },
        failure: (error) {
          emit(AuthState.fail("please try again later"));
        },
      );
    } catch (e) {
      emit(AuthState.fail("please try again later"));
    }
  }

  Future<void> logIn(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final request = LoginRequest(email: email, password: password);

      final ApiResult<LoginResponse> result = await repo.logIn(request);
      result.when(
        success: (LoginResponse response) async {
          await prefs.setSecureData(SharedPrefKey.token, response.token);
          await prefs.setSecureData(SharedPrefKey.role, response.role);
          emit(AuthState.success(response));
        },
        failure: (error) {
          emit(AuthState.fail(error));
        },
      );
    } catch (e) {
      emit(
        AuthState.fail(
          "Please try again later and make sure of the email and password",
        ),
      );
    }
  }
}
