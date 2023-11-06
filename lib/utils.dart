import 'package:flutter/material.dart';

class Utils {
  Utils._();

  static Color shiftColor(Color color, double shift) {
    if (shift == 1) {
      return color;
    }

    final hsvColor = HSVColor.fromColor(color).withSaturation(shift);
    return hsvColor.toColor();
  }

  static String getTime(Duration duration) {
    if (duration == Duration.zero) {
      return '00:00';
    }
    final millSecond = duration.inMilliseconds;

    final minute = millSecond / 1000 ~/ 60;
    final second = millSecond ~/ 1000 % 60;

    if (minute < 10) {
      if (second < 10) {
        return '0$minute:0$second';
      } else {
        return '0$minute:$second';
      }
    } else {
      if (second < 10) {
        return '$minute:0$second';
      } else {
        return '$minute:$second';
      }
    }
  }

  static bool isArtistIllegal(String? artist) {
    if (artist == null || artist.isEmpty) {
      return false;
    }
    artist = artist.trim().toLowerCase();
    return artist == 'unknown' || artist == '<unknown>' || artist == '未知艺术家';
  }

  static bool isAlbumIllegal(String? album) {
    if (album == null || album.isEmpty) {
      return false;
    }
    album = album.trim().toLowerCase();
    return album == 'unknown' || album == '<unknown>' || album == '未知专辑';
  }

  static bool isTitleIllegal(String? name) {
    if (name == null || name.isEmpty) {
      return false;
    }
    name = name.trim().toLowerCase();
    return name == 'unknown' || name == '<unknown>' || name == '未知歌曲';
  }

  static String getNeteaseSearchKey(String title, String album, String? artist, bool searchAlbum) {
    bool titleLegal = !isTitleIllegal(title);
    bool albumLegal = !isAlbumIllegal(album);
    bool artistLegal = !isArtistIllegal(artist);

    if(searchAlbum) {
      if(titleLegal) {
        if(artistLegal) {
          return '$title-$artist';
        } else if(albumLegal) {
          return '$title-$album';
        }
      }
      if(albumLegal && artistLegal) {
        return '$artist-$album';
      }
    } else if(artistLegal){
      return artist!;
    }
    return '';
  }
}
