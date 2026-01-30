enum Mood {
  happy,
  sad,
  focused,
  relaxed,
  energetic,
  anxious,
  creative,
  neutral;

  String get label {
    switch (this) {
      case Mood.happy:
        return 'Happy 😊';
      case Mood.sad:
        return 'Sad 😢';
      case Mood.focused:
        return 'Focused 🧠';
      case Mood.relaxed:
        return 'Relaxed 😌';
      case Mood.energetic:
        return 'Energetic ⚡';
      case Mood.anxious:
        return 'Anxious 😰';
      case Mood.creative:
        return 'Creative 🎨';
      case Mood.neutral:
        return 'Neutral 😐';
    }
  }
}
