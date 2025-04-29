import 'package:flutter_bloc/flutter_bloc.dart';

enum PlayingStatus { playing, paused }

class PlayingStatusCubit extends Cubit<PlayingStatus> {
  PlayingStatusCubit() : super(PlayingStatus.paused);

  void play() => emit(PlayingStatus.playing);
  void pause() => emit(PlayingStatus.paused);
}
