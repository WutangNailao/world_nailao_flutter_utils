class TimeInterval {
  final int dayLag;

  final int hourLag;

  final int minLag;

  final int secLag;

  TimeInterval(this.dayLag, this.hourLag, this.minLag, this.secLag);

  @override
  String toString() {
    return 'TimeInterval{dayLag: $dayLag, hourLag: $hourLag, minLag: $minLag, secLag: $secLag}';
  }
}
