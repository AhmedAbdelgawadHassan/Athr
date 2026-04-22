/// Strips Arabic diacritics (tashkeel) and common Quranic annotation marks
/// so search matches regardless of vocalization.
String stripArabicDiacriticsForSearch(String text) {
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= 0x064B && rune <= 0x065F) continue;
    if (rune == 0x0670) continue;
    if (rune >= 0x06D6 && rune <= 0x06ED) continue;
    if (rune >= 0x08F0 && rune <= 0x08FF) continue;
    buffer.writeCharCode(rune);
  }
  return buffer.toString();
}
