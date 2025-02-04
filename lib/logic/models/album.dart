import 'package:audio_service/audio_service.dart';
import 'package:clock/clock.dart';
import 'package:sweyer/sweyer.dart';

class Album extends PersistentQueue {
  @override
  ContentType get type => ContentType.album;

  final String album;
  final String? albumArt;
  final String artist;
  final int artistId;
  final int firstYear;
  final int? lastYear;
  final int numberOfSongs;

  @override
  String get title => album;

  /// Returns songs that belong to this album.
  @override
  List<Song> get songs {
    return ContentControl.instance.getContent(ContentType.song).fold<List<Song>>([], (prev, el) {
      if (el.albumId == id) {
        prev.add(el.copyWith(origin: this));
      }
      return prev;
    })
      ..sort(_compareSongs);
  }

  @override
  int get length => numberOfSongs;

  @override
  bool get playable => true;

  /// Gets album normalized year.
  int get year {
    return lastYear == null || lastYear! < 1000 ? clock.now().year : lastYear!;
  }

  /// Returns string in format `album name • year`.
  String get nameDotYear {
    return ContentUtils.appendYearWithDot(album, year);
  }

  /// Returns string in format `Album • year`.
  String albumDotName(AppLocalizations l10n) {
    return ContentUtils.appendYearWithDot(l10n.album, year);
  }

  /// Returns the album artist.
  Artist getArtist() => ContentControl.instance.state.artists.firstWhere((el) => el.id == artistId);

  const Album({
    required int id,
    required this.album,
    required this.albumArt,
    required this.artist,
    required this.artistId,
    required this.firstYear,
    required this.lastYear,
    required this.numberOfSongs,
  }) : super(id: id);

  @override
  AlbumCopyWith get copyWith => _AlbumCopyWith(this);

  @override
  MediaItem toMediaItem() {
    return MediaItem(
      id: id.toString(),
      album: null,
      defaultArtBlendColor: staticTheme.appThemeExtension.artColorForBlend.value,
      artUri: null,
      title: album,
      artist: ContentUtils.localizedArtist(artist, staticl10n),
      genre: null,
      rating: null,
      extras: null,
      playable: false,
    );
  }

  @override
  SongOriginEntry toSongOriginEntry() {
    return SongOriginEntry(
      type: SongOriginType.album,
      id: id,
    );
  }

  factory Album.fromMap(Map map) {
    return Album(
      id: map['id'] as int,
      album: map['album'] as String,
      albumArt: map['albumArt'] as String?,
      artist: map['artist'] as String,
      artistId: map['artistId'] as int,
      firstYear: map['firstYear'] as int,
      lastYear: map['lastYear'] as int,
      numberOfSongs: map['numberOfSongs'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'album': album,
        'albumArt': albumArt,
        'artist': artist,
        'artistId': artistId,
        'firstYear': firstYear,
        'lastYear': lastYear,
        'numberOfSongs': numberOfSongs,
      };

  /// Compare [song1] with [song2]. This can be used to sort the tracks of the album.
  int _compareSongs(Song song1, Song song2) => song1.trackPosition == song2.trackPosition
      ? song1.title.compareTo(song2.title)
      : song2.trackPosition == null
          ? -1
          : song1.trackPosition?.compareTo(song2.trackPosition!) ?? 1;
}

/// The `copyWith` function type for [Album].
abstract class AlbumCopyWith {
  Album call({
    int id,
    String album,
    String albumArt,
    String artist,
    int artistId,
    int firstYear,
    int? lastYear,
    int numberOfSongs,
  });
}

/// The implementation of [Album]'s `copyWith` function allowing
/// parameters to be explicitly set to null.
class _AlbumCopyWith extends AlbumCopyWith {
  static const _undefined = Object();

  /// The object this function applies to.
  final Album value;

  _AlbumCopyWith(this.value);

  @override
  Album call({
    Object id = _undefined,
    Object album = _undefined,
    Object albumArt = _undefined,
    Object artist = _undefined,
    Object artistId = _undefined,
    Object firstYear = _undefined,
    Object? lastYear = _undefined,
    Object numberOfSongs = _undefined,
  }) {
    return Album(
      id: id == _undefined ? value.id : id as int,
      album: album == _undefined ? value.album : album as String,
      albumArt: albumArt == _undefined ? value.albumArt : albumArt as String,
      artist: artist == _undefined ? value.artist : artist as String,
      artistId: artistId == _undefined ? value.artistId : artistId as int,
      firstYear: firstYear == _undefined ? value.firstYear : firstYear as int,
      lastYear: lastYear == _undefined ? value.lastYear : lastYear as int?,
      numberOfSongs: numberOfSongs == _undefined ? value.numberOfSongs : numberOfSongs as int,
    );
  }
}
