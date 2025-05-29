import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/domain/usecases/user/upload_generate_playlist.dart';
import 'package:notspotify/service_locator.dart';

class GeneratePlaylistsCubit extends Cubit<bool> {
  GeneratePlaylistsCubit() : super(false);

  Future<void> generateAndUpload(List<String> genres) async {
    emit(false); // Emit initial state
    final result = await sl<UploadGeneratePlaylistsUseCase>().call(
      params: genres,
    );
    result.fold((error) => emit(false), (_) => emit(true));
  }
}
