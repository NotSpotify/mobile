import 'package:notspotify/common/helpers/playlist/acoustic_templates.dart';
import 'package:notspotify/common/helpers/playlist/chill_templates.dart';
import 'package:notspotify/common/helpers/playlist/dance_templates.dart';
import 'package:notspotify/common/helpers/playlist/emotional_templates.dart';
import 'package:notspotify/common/helpers/playlist/energetic_templates.dart';
import 'package:notspotify/common/helpers/playlist/experimental_templates.dart';

final genrePlaylistsMap = {
  'Acoustic': acousticTemplates,
  'Chill': chillTemplates,
  'Dance': danceTemplates,
  'Emotional': emotionalTemplates,
  'Energetic': energeticTemplates,
  'Experimental': experimentalTemplates,
};
