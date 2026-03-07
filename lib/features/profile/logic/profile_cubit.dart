import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import '../data/repo/profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  ProfileCubit(this._repo) : super(const ProfileState.initial());

  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  // Get Profile
  Future<void> getProfile() async {
    emit(const ProfileState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const ProfileState.fail("Authentication token not found"));
        return;
      }

      final profile = await _repo.getProfile(token);
      emit(ProfileState.success(profile));
    } catch (e) {
      emit(ProfileState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to load profile. Please try again.",
      ));
    }
  }
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? imagePath,
  }) async {
    emit(const ProfileState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const ProfileState.fail("Authentication token not found"));
        return;
      }
      final result = await _repo.updateProfile(
        token: token,
        name: name,
        email: email,
        phone: phone,
        imagePath: imagePath,
      );
      emit(ProfileState.success(result));
      await getProfile();
    } catch (e) {
      emit(ProfileState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to update profile. Please try again.",
      ));
    }
  }

  Future<void> deleteProfileImage() async {
    emit(const ProfileState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const ProfileState.fail("Authentication token not found"));
        return;
      }
      final result = await _repo.deleteProfileImage(token);
      emit(ProfileState.success(result));
      await getProfile();
    } catch (e) {
      emit(ProfileState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to delete image. Please try again.",
      ));
    }
  }
}