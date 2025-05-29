import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/domain/entities/song/song.dart';

class NowPlayingCubit extends Cubit<SongEntity?> {
  NowPlayingCubit() : super(null);

  void setSong(SongEntity song) {
    emit(song);
  }

  void stop() {
    emit(null); 
  }
}
