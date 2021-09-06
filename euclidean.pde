
import java.util.Arrays;
import java.lang.reflect.Method;
import javax.sound.midi.MidiMessage; 
import themidibus.*; 

color lightBlue = color(0, 116, 217); 
color darkBlue = color(0, 45, 90); 

MidiBus myBus; 
String[] availableInputs, availableOutputs;

import controlP5.*;
ControlP5 cp5;
GUI gui;

StepSequencer StepSequencer;
PatternsCollector pc;
int currentStep = 0;

PFont fontAwesome;
void setup() {
  //fullScreen(P2D, 2);
  size(700, 700);
  myBus = new MidiBus(this, "loopMIDI Port", "loopMIDI Port", "loopMIDI Port") ;
  //myBus = new MidiBus(this, -1, -1, "loopMIDI Port") ;
  fontAwesome = createFont("fontawesome-webfont.ttf", 20);

  availableInputs = MidiBus.availableInputs();
  availableOutputs = MidiBus.availableOutputs();

  StepSequencer = new StepSequencer(60);
  pc = new PatternsCollector();
  //StepSequencer.start();

  gui = new GUI(this);
}


void draw() {
  background(255);
  int patternStep = StepSequencer.getCurrentPatternStep();


  if (StepSequencer.stepped) {
    currentStep = StepSequencer.getStep();
    if (patternStep==0) {
      myBus.sendNoteOff(0, 36, 127);
    } else if (patternStep==1) {
      myBus.sendNoteOff(0, 36, 127);
      myBus.sendNoteOn(0, 36, 127);
    } else {
      fill(255, 0, 0);
    }
  }

  fill(0);
  float angle = StepSequencer.pattern.angle;
  pushMatrix();
  translate(width/2, height/2);
  scale(sqrt(min(width-120, height-120)/120));

  push();
  rotate(-HALF_PI);
  //rotate(-newStep * angle);
  StepSequencer.pattern.display();
  pop();

  if (StepSequencer.isRunning) {
    push();
    if (patternStep==1) fill(lightBlue); 
    else fill(darkBlue); 
    noStroke();
    rotate(-PI);
    rotate(StepSequencer.getFloatStep() * angle);
    circle(0, 125, 12);
    pop();
  }
  popMatrix();


  StepSequencer.run();

  fill(darkBlue);
  String output = StepSequencer.toString();
  text(output, 10, height-6*(textAscent()-textDescent()));
  //text(patternStep, width/2, height/2);
}

void midiMessage(MidiMessage message, long timestamp, String bus_name) {


  int midi = (int)(message.getMessage()[0] & 0xFF);
  int note=0, velocity=0;
  if (message.getMessage().length>1) {
    note = (int)(message.getMessage()[1] & 0xFF);
    velocity = (int)(message.getMessage()[2] & 0xFF);
  }
  try {

    Class[] cls = new Class[4];
    cls[0] = int.class;
    cls[1] = int.class;
    cls[2] = int.class;
    cls[3] = String.class;
    Method handler = this.getClass().getMethod( "MidiHandler", cls );
    handler.invoke( this, midi, note, velocity, bus_name);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}
void MidiHandler(int midi, int note, int velocity, String bus)
{
  if (midi==248) {

    StepSequencer.gatheredMidi24ths++;
  } else if (midi==252) StepSequencer.reset();
  //else println( midi, note, velocity, bus);
}


void mousePressed() {

  if (mouseButton == CENTER) {
    int n = (int) map(mouseX, 0, width, 3, 32+1);
    int k = (int) map(mouseY, 0, width, n, 1);
    //StepSequencer.setPattern(n, k);
    cp5.getController("n").setValue(n);
    cp5.getController("k").setValue(k);

    //    StepSequencer.start();
  } else  if (mouseButton == RIGHT) {
    int n=(int) random(3, 32);
    int k=(int) random(1, n);
    cp5.getController("n").setValue(n);
    cp5.getController("k").setValue(k);

    StepSequencer.setPattern( n, k);
  }
}
