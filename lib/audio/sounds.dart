List<String> soundTypeToFilename(SfxType type) => switch (type) {
      SfxType.jump => const [
          'game.mp3',
        ],
      SfxType.doubleJump => const [
          'game.mp3',
        ],
      SfxType.hit => const [
          'hit1.mp3',
          'hit1.mp3',
        ],
      SfxType.damage => const [
          'loader.mp3',
          'loader.mp3',
        ],
      SfxType.score => const [
          'score1.mp3',
          'score1.mp3',
        ],
      SfxType.buttonTap => const [
          'click1.mp3',
          'click1.mp3',
          'click1.mp3',
          'click1.mp3',
        ]
    };

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.score:
    case SfxType.jump:
    case SfxType.doubleJump:
    case SfxType.damage:
    case SfxType.hit:
      return 0.4;
    case SfxType.buttonTap:
      return 1.0;
  }
}

enum SfxType {
  score,
  jump,
  doubleJump,
  hit,
  damage,
  buttonTap,
}
