
class StepSequencer {
  int bpm; 
  int step=0; 
  int quarterNoteDuration=4;
  int errors;

  //int[] pattern;
  Pattern pattern;

  ArrayList<Pattern> patterns = new ArrayList<Pattern>();

  int savedTime; 


  StepSequencer(int bpm) {
    this.bpm = bpm;


    setPattern();

  }

  

  void setPattern() {
    int n=(int) random(1, 32);
    int k=(int) random(1, n);

    setPattern( n, k);
  }

  void setPattern(int n, int k) {
    pattern=new EuclideanPattern(n, k);
    patterns.add(pattern);
  }

  void setPattern(Pattern newPattern) {

    pattern=newPattern;
    patterns.add(pattern);
  }

  // Starting the StepSequencer
  void start() {
    savedTime = millis();
    step = 0;
    errors = 0;
  }

  void run() {
    updateStep();
  }

  void updateStep() {
    int  totalTime = 60000/bpm;
    int passedTime = millis()- savedTime;
    int currentStep =(int) (passedTime / (totalTime/quarterNoteDuration));
    if (step<currentStep) {
      errors=passedTime-step*(totalTime/quarterNoteDuration);
      step=currentStep;
    }
  }
  int getStep() {
    
    return step;
  }
  int getCurrentPatternStep() {
    return pattern.getStep(step);
  }
  String toString() {
    return "bpm: "+bpm+"  [+/-: "+errors/(step+1)+" ms]"+"\nstep: "+step%pattern.getLength()+" ("+step+")"+" [[q="+quarterNoteDuration+"]]\npattern: "+pattern;
  }
}
