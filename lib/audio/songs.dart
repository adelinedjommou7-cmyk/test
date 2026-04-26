const List<Song> songs = [
  Song('hit1.mp3', 'Bit Forrest', artist: 'bertz'),
  Song('loader.mp3', 'Free Run', artist: 'TAD'),
  Song('game.mp3', 'Tropical Fantasy', artist: 'Spring Spring'),
];

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}
