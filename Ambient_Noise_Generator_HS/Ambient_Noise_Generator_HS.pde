
/*import libraries*/
import controlP5.*;
import processing.sound.*;

ControlP5 cp5;

//create variables for sounds//
WhiteNoise Wnoise;
SoundFile music1;
SoundFile music2;
SoundFile music3;

// perlin noise animation variable creation
float noiseOffset = 0;

//create variables for colours -> float variables which are converted to RGB later//
float Birds;
float Wind;
float Water;
float Static;
float Volume;

//create variable for master volume (controls volume slider)
float masterVolume = 1;

//set up screen//
void setup() {
  size(1000, 750);
  noStroke();
  cp5 = new ControlP5(this);

//set font
 PFont pfont = createFont("Monospaced", 16);
  ControlFont font = new ControlFont(pfont);
  cp5.setFont(font);

// set up sliders //
  ///slider one visual///
  cp5.addSlider("Birds")
    .setPosition(166, 350)
    .setSize(40, 200)
    .setRange(0, 1)
    .setValue(0.5)
    ;

  ///slider two visual///
  cp5.addSlider("Wind")
    .setPosition(333, 350)
    .setSize(40, 200)
    .setRange(0, 1)
    .setValue(0.5)
    ;

  ///slider three visual///
  cp5.addSlider("Water")
    .setPosition(500, 350)
    .setSize(40, 200)
    .setRange(0, 1)
    .setValue(0.5)
    ;

  ///slider four visual///
  cp5.addSlider("Static")
    .setPosition(666, 350)
    .setSize(40, 200)
    .setRange(0, 1)
    .setValue(0.5)
    ;

  ///slider five visual///
  cp5.addSlider("Volume")
    .setPosition(833, 350)
    .setSize(40, 200)
    .setRange(0, 1)
    .setValue(1)
    ;


  // set up sounds to play on project start//
  Wnoise = new WhiteNoise(this);
  Wnoise.play();

  music1 = new SoundFile(this, "assets/bird.mp3");
  music1.play();

  music2 = new SoundFile(this, "assets/wind.mp3");
  music2.play();

  music3 = new SoundFile(this, "assets/rain.mp3");
  music3.play();
}

// convert float values to RBG //
void draw() {

  //Convert slider values from 0-1 into RGB values from 0-255//
  int redValue = int(Birds * 255);
  int greenValue = int(Wind * 255);
  int blueValue = int(Water * 255);
  //Convert slider values from 0-1 into 0-100 for Perlin distortion//
  int distortion = int(Static * 100);


// Set background colour as colour defined by sliders //
  background(redValue, greenValue, blueValue);

//logic to make slider 4 control perlin distortion //
  //set size of box size that moves
  float cellSize = 20;

  //create outer loop (moves horizontally) //
  for (int x = 0; x < width; x += 10) {
    //create inner loop (moves vertiacally) //
    for (int y = 0; y < height; y += 10) {

      //generate perlin noise
      float n = noise(x * 0.01, y * 0.01, noiseOffset);
      float offset = map(n, 0, 1, -distortion, distortion);

      //ensures background remains the same colour as determined by other sliders
      fill(redValue + offset, greenValue + offset, blueValue + offset);
      noStroke();

      rect(x + offset, y + offset, cellSize, cellSize);
    }
  }

  noiseOffset += 0.01;
}


//actual logic to make sliders control colours and sounds//


// Slider 5 controls the master volume of all sounds
void Volume(float value) {
  Volume = value;
  masterVolume = value;

//other sliders play volume at level multiplied with master -> allows the other slider levels to be maintained 
// rather than reset //
  music1.amp(Birds * masterVolume);
  music2.amp(Wind * masterVolume);
  music3.amp(Water * masterVolume);
  Wnoise.amp(Static * masterVolume);
}

// Slider 1 controls red and bird sounds //
void Birds(float value) {
  Birds = value;
  music1.amp(value * masterVolume);
}


// Slider 2 controls green and wind/tree sounds //
void Wind(float value) {
  Wind = value;
  music2.amp(value * masterVolume);
}


// Slider 3 controls blue and water sounds //
void Water(float value) {
  Water = value;
  music3.amp(value * masterVolume);
}


// Slider 4 controls static (white noise) and perlin (perlin code above)
void Static(float value) {
  Static = value;
  Wnoise.amp(value * masterVolume);
}
