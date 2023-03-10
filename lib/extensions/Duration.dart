extension formatter on Duration {
  String toHoursMinutesSeconds() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(this.inSeconds.remainder(60));
    String result = "";
    if (this.inHours != 0) {
      result += "${this.inHours}:";
    }
    result += "$twoDigitMinutes:$twoDigitSeconds";
    return result;
  }
}
