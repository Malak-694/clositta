import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/auth/data/model/forgot_password_model.dart';
import 'package:chicora/features/auth/data/model/google_auth_model.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';
import 'package:chicora/features/auth/data/repo/auth_repo.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;
  final prefs = getIt<SharedPrefHelper>();

  static Future<void>? _googleSignInInitialization;

  AuthCubit(this.repo) : super(AuthState.initial());

  Future<void> _ensureGoogleSignInInitialized() {
    _googleSignInInitialization ??= GoogleSignIn.instance.initialize(
      serverClientId:
          '972503944615-ks98hr9b6vo82stucp3g2693fq7jt30d.apps.googleusercontent.com',
      clientId:
          '972503944615-ks98hr9b6vo82stucp3g2693fq7jt30d.apps.googleusercontent.com',
    );

    return _googleSignInInitialization!;
  }

  Future<void> signUp(
    String username,
    String email,
    String password,
    String confirmPassword,
    String phone,
    String role, {
    String? workshopLocation,
    String? workshopMapsUrl,
  }) async {
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
        location: rolefinal == 'tailor' ? workshopLocation?.trim() : null,
        mapsUrl: rolefinal == 'tailor' ? workshopMapsUrl?.trim() : null,
      );

      final ApiResult<SignUpResponse> result = await repo.signUp(request);
      result.when(
        success: (SignUpResponse response) async {
          emit(
            AuthState.success(
              "${response.message ?? 'Registered successfully'} — you can now log in.",
            ),
          );
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
          await prefs.setSecureData(SharedPrefKey.id, response.id);
          await prefs.setSecureData(SharedPrefKey.name, response.name);
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

  // In authentication_cubit.dart

  Future<void> googleAuth() async {
    try {
      final GoogleSignIn gSignIn = GoogleSignIn.instance;
      await _ensureGoogleSignInInitialized();

      final GoogleSignInAccount account = await gSignIn.authenticate();

      final GoogleSignInAuthentication auth = account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        emit(AuthState.fail("Google sign-in failed, please try again"));
        return;
      }
      final GoogleAuthRequestModel body = GoogleAuthRequestModel(
        idToken: idToken,
        role: 'customer',
      );
      final result = await repo.googleAuth(body);
      result.when(
        success: (GoogleAuthResponseModel response) async {
          await prefs.setSecureData(SharedPrefKey.token, response.token);
          await prefs.setSecureData(SharedPrefKey.role, response.role);
          await prefs.setSecureData(SharedPrefKey.id, response.id);
          await prefs.setSecureData(SharedPrefKey.name, response.name);
          emit(AuthState.success(response));
        },
        failure: (error) => emit(AuthState.fail(error)),
      );
    } on GoogleSignInException catch (e) {
      e;
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(const AuthState.initial());
        return;
      }
      emit(AuthState.fail("Google sign-in failed, please try again"));
    } catch (e) {
      e;
      emit(AuthState.fail("Google sign-in failed, please try again"));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(const AuthState.loading());
    try {
      final result = await repo.forgotPassword(
        ForgotPasswordRequest(email: email),
      );
      result.when(
        success: (MessageModel response) =>
            emit(AuthState.success(response.message ?? "Code sent")),
        failure: (error) => emit(AuthState.fail(error)),
      );
    } catch (e) {
      emit(AuthState.fail("Please try again later"));
    }
  }

  Future<void> verifyResetCode(String email, String code) async {
    emit(const AuthState.loading());
    try {
      final result = await repo.verifyResetCode(
        VerifyCodeRequest(email: email, code: code),
      );
      result.when(
        success: (MessageModel response) =>
            emit(AuthState.success(response.message ?? "Code verified")),
        failure: (error) => emit(AuthState.fail(error)),
      );
    } catch (e) {
      emit(AuthState.fail("Invalid code, please try again"));
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    emit(const AuthState.loading());
    try {
      final result = await repo.resetPassword(
        ResetPasswordRequest(email: email, newPassword: newPassword),
      );
      result.when(
        success: (MessageModel response) =>
            emit(AuthState.success(response.message ?? "Password reset")),
        failure: (error) => emit(AuthState.fail(error)),
      );
    } catch (e) {
      emit(AuthState.fail("Please try again later"));
    }
  }
}
