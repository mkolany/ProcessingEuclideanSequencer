import controlP5.*;
ControlP5 cp5;

StepSequencer StepSequencer;
void setup() {
  size(500, 500);

  cp5 = new ControlP5( this );
  StepSequencer = new StepSequencer(60);
  StepSequencer.start();

  cp5 = new ControlP5( this );

  cp5.addKnob("bpm")
    .setBroadcast(false)
    .setRange(30, 300)
    .plugTo( StepSequencer)
    .setValue(StepSequencer.bpm)
    .setBroadcast(true)
    ;
  cp5.addKnob("quarterNoteDuration")
    .setBroadcast(false)
    .setRange(1, 32)
    .plugTo( StepSequencer)
    .setValue(StepSequencer.quarterNoteDuration)
    .setCaptionLabel("q")
    .setBroadcast(true)
    ;
  cp5.addKnob("n")
    .setBroadcast(false)
    .setRange(1, 32)
    .plugTo( StepSequencer.pattern)
    .setValue(StepSequencer.pattern.getN())
    .setBroadcast(true)
    ;
  cp5.addKnob("k")
    .setBroadcast(false)
    .setRange(1, 32)
    .plugTo( StepSequencer.pattern)
    .setValue(StepSequencer.pattern.getK())
    .setBroadcast(true)
    ;
}
void controlEvent(ControlEvent ev) {
  float value = ev.getController().getValue();
  String name = ev.getController().getName();

  println(name, value);

  if (name=="n" || name=="k") {
    int n = (int) cp5.getController("n").getValue();
    int k = (int) cp5.getController("k").getValue();
    //if(k<n) StepSequencer.setPattern(n, k);
    StepSequencer.setPattern(n, k);
  } else if (name=="bpm" || name=="quarterNoteDuration")  StepSequencer.start();
}
void draw() {
  int patternStep = StepSequencer.getCurrentPatternStep();
  if (patternStep==0) {
    background(0);
    fill(255);
  } else if (patternStep==1) {
    background(255);
    fill(0);
  } else {
    background(map(patternStep, 2, 32, 0, 255), map(patternStep, 2, 32, 100, 155), map(patternStep, 2, 32, 20, 155));
    fill(255, 0, 0);
  } 

  pushMatrix();
  translate(width/2, height/2);
  rotate(StepSequencer.getStep()*TWO_PI/ StepSequencer.pattern.getLength());
  StepSequencer.pattern.display();
  popMatrix();


  StepSequencer.run();

  String output = StepSequencer.toString();
  text(output, 10, height-6*(textAscent()-textDescent()));
  text(patternStep, width/2, height/2);
}
void mousePressed() {

  if (mouseButton == CENTER) {
    int n = (int) map(mouseX, 0, width, 1, 32+1);
    int k = (int) map(mouseY, 0, width, n, 1);
    StepSequencer.setPattern(n, k);


    StepSequencer.start();
  } else  if (mouseButton == RIGHT) {
    StepSequencer.setPattern();
  }
}
