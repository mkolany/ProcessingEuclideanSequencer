
class StepSequencer {
  int bpm; 
  boolean stepped=true; 
  float  floatStep;
  float errors;

  boolean isRunning = false;
  boolean externalMidiClock = false;
  int gatheredMidi24ths=0;
  int quarterNoteDuration=1;

  EuclideanPattern pattern = new EuclideanPattern();



  int savedTime; 


  StepSequencer(int bpm) {
    this.bpm = bpm;

    int n=(int) random(1, 32);
    int k=(int) random(1, n);

    pattern.setPattern( n, k);
  }

  void setPattern(int n, int k) {
    ((EuclideanPattern) pattern).setPattern(n, k);

    //patterns.add(this.pattern.toString());
  }

  void reset() {
    println("resetting");
    savedTime = millis();
    floatStep = 0;
    errors = 0;
    gatheredMidi24ths=0;
  }

  void start() {
    reset();
    StepSequencer.isRunning = true;
  }

  void stop() {
    reset();
    StepSequencer.isRunning = false;
  }

  void run() {
    if (isRunning) {

      if (externalMidiClock) updateExternalStep();
      else updateStep();
    }
  }

  void updateStep() {
    float  totalTime = 60000/bpm;
    float passedTime = millis()- savedTime;

    float currentStep = (passedTime / (totalTime/quarterNoteDuration));

    int step = (int) ( currentStep);
    int lastStep = (int) ( floatStep);

    floatStep = currentStep;
    if (lastStep < step) {
      errors=passedTime-step*(totalTime/quarterNoteDuration);
      stepped=true;
    } else stepped=false;

    //    println(stepped, lastStep, step, floatStep, currentStep);
  }
  void updateExternalStep() {
    floatStep = ((gatheredMidi24ths*quarterNoteDuration)/24.0);
  }
  int getStep() {

    return (int) (floatStep);
  }
  float getFloatStep() {

    return ( floatStep);
  }

  int getCurrentPatternStep() {
    return pattern.getStep(this.getStep());
  }
  String toString() {
    return "isPlaying: "+isRunning
      +"\nbpm: "+bpm+"  ["+errors/( (int) ( floatStep)+1)+" ms]"
      +"\nstep: "+ (int) ( floatStep)
      +"\n"+pattern;
  }
}
