
class Pattern {
  int[] pattern;
  int radius=100;
  float angle;
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

  int getStep(int step) {
    int currentStep = step%pattern.length;
    return pattern[currentStep];
  }
  int getLength() {
    return pattern.length;
  }


  void display() {
    int npoints = this.getLength();

    angle = TWO_PI / npoints;

    push();    
    strokeWeight(7.5);
    stroke(darkBlue);
    fill(lightBlue);    
    beginShape();
    for (int n = 0; n < npoints; n ++) {
      float a =n*angle;
      float sx =  cos(a) * radius;
      float sy =  sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);


    strokeWeight(3);
    stroke(255, 150);
    fill(lightBlue);
    fill(255);
    //if (StepSequencer.getCurrentPatternStep()==1) fill((255));
    if (StepSequencer.getCurrentPatternStep()==1) noStroke();

    beginShape();

    int k=0;
    for (int n = 0; n < npoints; n ++) {
      float a =n*angle;
      float sx =  cos(a) * radius*0.95;
      float sy =  sin(a) * radius*0.95;
      if (pattern[n]!=0) {
        vertex(sx, sy);
        k++;
      }
    }
    if (k==1) vertex(0, 0);
    endShape(CLOSE);



    beginShape(POINTS);
    for (int n = 0; n < npoints; n ++) {
      float a =n*angle;
      float sx =  cos(a) * radius*1.15;
      float sy =  sin(a) * radius*1.15;

      if (pattern[n]!=0) {  
        strokeWeight(5);
        stroke(darkBlue);
      } else {  
        strokeWeight(4);
        stroke(0, 45, 90, 100);
      }
      vertex(sx, sy);
    }
    endShape();
    pop();

    if (mousePressed) this.clicked(mouseX, mouseY);
  }

  void clicked( int mx, int my) {
    //println(mx,  my);
    if ( mx > width/2-radius && mx < width/2+radius  && my > height/2-radius && my <height/2+radius) {
      println("da");
      mousePressed=false;
    }
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


    setPattern( n, k );
  }
  void setPattern() {
    this.setPattern(bjorklund2(n, k));
  }
  void setPattern(int n, int k) { 
    this.n = n;
    this.k = k;
    this.setPattern(bjorklund2(n, k));
  }
  int getN() {
    return n;
  } 
  int getK() {
    return k;
  }
  String shortString() {
    return "("+n+","+ k+")";
  }

  @Override
    String toString() {
    return "("+n+","+ k+")=["+join(nf(pattern, 0), ",")+"]";
  }
}

int invertColor (int col_) {

  return color(255-red(col_), 255-green(col_), 255-blue(col_));
}
