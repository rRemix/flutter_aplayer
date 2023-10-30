/// result : {"songs":[{"id":16435051,"name":"Rolling in the Deep","artists":[{"id":46487,"name":"Adele","picUrl":null,"alias":[],"albumSize":0,"picId":0,"fansGroup":null,"img1v1Url":"http://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg","img1v1":0,"trans":null}],"album":{"id":1515350,"name":"Rolling in the Deep","artist":{"id":0,"name":"","picUrl":null,"alias":[],"albumSize":0,"picId":0,"fansGroup":null,"img1v1Url":"http://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg","img1v1":0,"trans":null},"publishTime":1295107200000,"size":2,"copyrightId":390012,"status":1,"picId":109951168981890417,"mark":0},"duration":228093,"copyrightId":390012,"status":0,"alias":[],"rtype":0,"ftype":0,"mvid":5056,"fee":8,"rUrl":null,"mark":1318912}],"hasMore":true,"songCount":316}
/// code : 200

class NSong {
  final int code;
  final Result? result;

  NSong({this.code = 0, this.result});

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'result': result,
    };
  }

  factory NSong.fromMap(dynamic json) {
    return NSong(
      code: json['code'] as int,
      result: Result.fromMap(json['result']),
    );
  }
}

class Result {
  List<Song>? songs;

  Result({required this.songs});

  Map<String, dynamic> toMap() {
    return {
      'songs': songs,
    };
  }

  Result.fromMap(dynamic json) {
    if(json.containsKey('songs')) {
      songs = <Song>[];
      json['songs'].forEach((v) {
        songs?.add(Song.fromMap(v));
      });
    }
  }
}

class Song {
  final int id;
  final Album? album;
  final int? score;

  Song({required this.id, required this.album, this.score = 50});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'album': album,
      'score': score,
    };
  }

  factory Song.fromMap(dynamic map) {
    return Song(
      id: map['id'] as int,
      album: Album.fromMap(map['album']),
      score: map['score'] as int?,
    );
  }
}

class Album {
  final String? picUrl;

  Album({this.picUrl});

  Map<String, dynamic> toMap() {
    return {
      'picUrl': picUrl,
    };
  }

  factory Album.fromMap(dynamic map) {
    return Album(
      picUrl: map['picUrl'] as String?,
    );
  }
}