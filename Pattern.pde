class Pattern {
  int[] pattern;
  Pattern (int[] pattern) {
    this.pattern=pattern;
  }

  //empty:
  Pattern () {
    this(new int[16]);
  }

  int[] getPattern () {
    return this.pattern;
  }
  void setPattern (int[] pattern) {
    this.pattern=pattern;
  }
  void updatePattern () {
  }
  int getStep(int step) {
    int currentStep = step%pattern.length;
    return pattern[currentStep];
  }
  int getLength() {
    return pattern.length;
  }
  int getN() {
    return 0;
  } 
  int getK() {
    return 0;
  }

  void display() {
    int npoints = this.getLength();
    float radius=100;
    float angle = TWO_PI / npoints;

    float oldStrokeWeight = g.strokeWeight;
    int oldStroke = g.strokeColor;
    int oldFill = g.fillColor;
    stroke(oldStroke);
    fill(oldFill);    
    noStroke();
    beginShape();
    for (int n = 0; n < npoints; n ++) {
      float a =n*angle;
      float sx =  cos(a) * radius;
      float sy =  sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
    stroke(invertColor(oldFill));
    fill(invertColor(oldFill));
    noFill();
    strokeWeight(5);
    beginShape();
    for (int n = 0; n < npoints; n ++) {
      float a =n*angle;
      float sx =  cos(a) * radius;
      float sy =  sin(a) * radius;
      if (pattern[n]!=0) vertex(sx, sy);
    }
    endShape(CLOSE);
    strokeWeight(oldStrokeWeight);
    stroke(oldStroke);
    fill(oldFill);
  }
  String toString() {
    return "["+join(nf(pattern, 0), ", ")+"]";
  }
}

class EuclideanPattern extends Pattern {
  int n, k;
  EuclideanPattern (int n, int k) {
    super(bjorklund2(n, k));

    this.n = n;
    this.k = k;
  }

  EuclideanPattern () {
    super();
    int n=(int) random(1, 32);
    int k=(int) random(1, n);

    this.n = n;
    this.k = k;
    updatePattern();
  }
  @Override
    void updatePattern() {
    this.setPattern(bjorklund2(n, k));
  }
  @Override
    int getN() {
    return n;
  } 
  @Override
    int getK() {
    return k;
  }


  @Override
    String toString() {
    return "("+n+","+ k+")=["+join(nf(pattern, 0), ",")+"]";
  }
}

int invertColor (int col_) {

  return color(255-red(col_), 255-green(col_), 255-blue(col_));
}
