class PatternsCollector {
  ArrayList<Pattern> patterns = new ArrayList<Pattern>();
  PatternsCollector() {
  }
  void addPattern (Pattern pattern) {
    this.patterns.add(pattern);
    println(this.patterns.size());
  }
  String[] getPatternArray() {
    return patterns.toArray(new String[0]);
  }
}
