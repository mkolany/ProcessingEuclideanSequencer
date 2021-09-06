import java.util.Map;
import java.util.LinkedHashMap;

class GUI {

  LinkedHashMap<String, Controller> hm = new LinkedHashMap<String, Controller>();


  GUI(PApplet thePApplet) {
    cp5 = new ControlP5(thePApplet);
    Group g1 = cp5.addGroup("song settings")
      .setPosition(10, 20)
      .setWidth(150)
      .setBackgroundHeight(110)
      ;

    Group g2 = cp5.addGroup("pattern settings")
      .setPosition(180, 20)
      .setWidth(150)
      .setBackgroundHeight(110)
      ; 
    Group g3 = cp5.addGroup("midi settings")
      .setPosition(350, 20)
      .setWidth(150)
      .setBackgroundHeight(110)
      ;

    Slider sliderBPM = cp5.addSlider("bpm")
      .setBroadcast(false)
      .setRange(50, 180)
      .plugTo( StepSequencer)
      .setValue(StepSequencer.bpm)
      .setSize(110, 20)
      .setPosition(20, 10)
      .setGroup(g1)
      ;

    Slider sliderQ = cp5.addSlider("quarterNoteDuration")
      .setBroadcast(false)
      .setRange(1, 32)
      .plugTo( StepSequencer)
      .setValue(StepSequencer.quarterNoteDuration)
      .setCaptionLabel("q") 
      .setSize(110, 10)
      .setPosition(20, 40)
      .setGroup(g1)
      ;

    Slider sliderN = cp5.addSlider("n")
      .setBroadcast(false)
      .setRange(3, 32) 
      .plugTo( StepSequencer.pattern)
      .setValue(((EuclideanPattern) StepSequencer.pattern).getN())
      .setSize(10, 50)
      .setPosition(100, 10)
      .setGroup(g2)
      ;
    Slider sliderK = cp5.addSlider("k")
      .setBroadcast(false)
      .setRange(1, 32)
      .plugTo( StepSequencer.pattern)
      .setValue(((EuclideanPattern) StepSequencer.pattern).getK())
      .setSize(10, 50)
      .setPosition(120, 10)
      .setGroup(g2)
      ;
    Button buttonRandomPattern = cp5.addButton("buttonRandomPattern")
      .setBroadcast(false)
      .setCaptionLabel("RAND")
      .setSize(30, 20)
      .setPosition(60, 10)
      .setGroup(g2)
      ;
    Button buttonAddPattern = cp5.addButton("buttonAddPattern")
      .setBroadcast(false)
      .setCaptionLabel("SAVE")
      .setSize(30, 20)
      .setPosition(60, 40)
      .setGroup(g2)
      ;

    ScrollableList selectPattern = cp5.addScrollableList("selectPattern")
      .setBroadcast(false)
      .addItems( pc.getPatternArray() )
      .setOpen(true)
      .setType(ScrollableList.DROPDOWN)
      //.setType(ScrollableList.LIST) 
      .setGroup(g2) 
      .setBarHeight(20)
      .setItemHeight(15)
      .setSize(40, 110)
      .setPosition(10, 10)
      ;
    selectPattern.getCaptionLabel().setVisible(false);

    int inputIndex = ( Arrays.asList(availableInputs).indexOf(myBus.attachedInputs()[0]) );
    int outputIndex = ( Arrays.asList(availableOutputs).indexOf(myBus.attachedOutputs()[0]) );
    ScrollableList dropdownInput = cp5.addScrollableList("selectMidiInput")
      .setBroadcast(false)
      .addItems(availableInputs)
      .setValue(inputIndex)
      .setLabel(myBus.attachedInputs()[0])
      //.setCaptionLabel("INPUT")
      .setOpen(false)
      .setType(ScrollableList.DROPDOWN)
      //.setType(ScrollableList.LIST) 
      .setGroup(g3) .setBarHeight(20)
      .setItemHeight(15)
      .setSize(60, 110)
      .setPosition(10, 10)
      ;

    ScrollableList dropdownOutput = cp5.addScrollableList("selectMidiOutput")
      .setBroadcast(false)
      .setBarHeight(20)
      .setItemHeight(15)
      .addItems(availableOutputs)
      .setValue(outputIndex)
      .setLabel(myBus.attachedOutputs()[0])
      //.setCaptionLabel("OUTPUT")
      .setOpen(false)
      .setType(ScrollableList.DROPDOWN)
      .setGroup(g3)
      .setBarHeight(20)
      .setItemHeight(15)
      .setSize(60, 110)
      .setPosition(80, 10)
      ;


    Icon playButton=cp5.addIcon("isRunning", 1)
      .setBroadcast(false)
      .plugTo( StepSequencer)
      .setFont(fontAwesome)
      .setFontIcons(#00f04c, #00f04b)
      .setSwitch(true)
      .setWidth(20)
      ;

    Toggle externalMidi = cp5.addToggle("externalMidiClock")
      .setBroadcast(false)
      .plugTo( StepSequencer)
      .setImages(loadImage("midi128.png"), loadImage("midi128_on.png"))
      .setWidth(20)
      ;

    hm.put("BPM", sliderBPM);
    hm.put("Q", sliderQ);
    hm.put("selectPattern", selectPattern);
    hm.put("N", sliderN);
    hm.put("K", sliderK);
    hm.put("input", dropdownInput);
    hm.put("output", dropdownOutput);
    hm.put("buttonRandomPattern", buttonRandomPattern);
    hm.put("buttonAddPattern", buttonAddPattern);
    hm.put("isPlaying", playButton);
    hm.put("externalMidi", externalMidi);

    styleControllers( );
    positionControllers("RIGHT", "TOP", playButton);
    positionControllers("RIGHT", "BOTTOM", externalMidi );


    setBroadcasts(true);
  }

  void styleControllers() {
    for (Map.Entry me : hm.entrySet()) {
      Controller c = (Controller) (me.getValue());


      c.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
      //c.getCaptionLabel().setSize(15);
      c.getValueLabel().setSize(10);
      c.updateSize();

      if (c.getClass()==Slider.class) {
        c.setColorCaptionLabel(color(darkBlue));

        if (c.getWidth()>c.getHeight()) c.getCaptionLabel().align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER);
        else c.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
      }
      // else if  (  c.getName()==hm.get("isPlaying").getName() ||   c.getName()==hm.get("externalMidi").getName()) c.setWidth(20);
    }
  }

  void positionControllers(String alignmentX, String alignmentY, Controller ...controllers) {
    int count=0;

    for (Controller c : controllers) {
      int xPos=30, yPos=20;
      yPos += 30*count;

      if (alignmentX=="LEFT") xPos = 30;
      else if (alignmentX=="RIGHT") xPos = width-c.getWidth()-xPos;
      else if (alignmentX=="CENTER") {
        xPos = width/2-c.getWidth()+(c.getWidth()+10)*count;
        yPos = 20;
      }
      if (alignmentY=="BOTTOM") yPos = height-c.getHeight()-yPos;

      c.setPosition(xPos, yPos);
      count++;
    }
  }

  void setBroadcasts(boolean b) {
    for (Map.Entry me : hm.entrySet()) {
      Controller c = (Controller) (me.getValue());
      c.setBroadcast(b);
    }
  }


  void updateRanges() {
    setBroadcasts(false);
    float k = hm.get("K").getValue();
    k = k<3 ? 3 : k;
    hm.get("Q").setMax(hm.get("N").getValue());
    hm.get("K").setMax(hm.get("N").getValue());
    hm.get("N").setMin(k);

    styleControllers();
    setBroadcasts(true);
  }
}
void controlEvent(ControlEvent ev) {
  float value = ev.getController().getValue();
  String name = ev.getController().getName();



  println(name, value);
  if (name=="bpm" ||name=="quarterNoteDuration")  StepSequencer.reset();

  if (name=="n" || name=="k") {
    gui.updateRanges();
    StepSequencer.setPattern((int)  gui.hm.get("N").getValue(), (int)  gui.hm.get("K").getValue());
  }
  //else if (name=="bpm" || name=="quarterNoteDuration")  sendMidiOffs();
}
void selectMidiInput(int n) {
  myBus.clearInputs();
  myBus.addInput(n);
}
void selectMidiOutput(int n) {
  myBus.clearOutputs();
  myBus.addOutput(n);
}
void externalMidiClock(boolean b) {
  StepSequencer.gatheredMidi24ths=0;
  StepSequencer.reset();
}

void isRunning(boolean b) {
  if (b) StepSequencer.start();
  else StepSequencer.stop();
  StepSequencer.reset();
}

void buttonAddPattern () {
  pc.addPattern(StepSequencer.pattern);
  ((ScrollableList) cp5.getController("selectPattern")).addItem((StepSequencer.pattern).shortString(), StepSequencer.pattern );
}
void selectPattern(int n) {
  //println(cp5.get(ScrollableList.class, "selectPattern").getItems().get(n));  
 
  EuclideanPattern ep = (EuclideanPattern) ( pc.patterns.get(n));  
  int n_ = (ep.getN());  
  int k_ = (ep.getK());
  println(n, n_, k_);
  //StepSequencer.setPattern(n_, k_);
}
