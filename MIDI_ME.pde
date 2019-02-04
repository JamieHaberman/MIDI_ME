import processing.video.*;

import ddf.minim.analysis.*;
import ddf.minim.*;

int numSamples = 42;
int numRows = 6;
int numCols = 7;
Audio[] audio;
Visualization[] vis;

Minim       minim;
FFT []  fft = new FFT[numSamples];

AudioPlayer[] sample = new AudioPlayer[numSamples]; 
float[] diameter = new float[numSamples];
float[] area_sum = new float[numSamples];
float[] xpos = new float[numSamples];
float[] ypos = new float[numSamples];

ShimodairaOpticalFlow SOF;

void setup () {

  size(1440, 840, P3D);

  ///////////////////load samples into sample array//////////////////

  minim = new Minim(this);

  sample[41] = minim.loadFile("jamie 21-Addictive Keys.64.wav", 512);  
  sample[40] = minim.loadFile("jamie 21-Addictive Keys.64.wav", 512);
  sample[39] = minim.loadFile("jamie 20-Addictive Keys.64.wav", 512);
  sample[38] = minim.loadFile("jamie 20-Addictive Keys.64.wav", 512);
  sample[37] = minim.loadFile("jamie 19-Addictive Keys.64.wav", 512);
  sample[36] = minim.loadFile("jamie 19-Addictive Keys.64.wav", 512);
  sample[35] = minim.loadFile("jamie 18-Addictive Keys.64.wav", 512);
  sample[34] = minim.loadFile("jamie 18-Addictive Keys.64.wav", 512);
  sample[33] = minim.loadFile("jamie 17-Addictive Keys.64.wav", 512);
  sample[32] = minim.loadFile("jamie 17-Addictive Keys.64.wav", 512);
  sample[31] = minim.loadFile("jamie 16-Addictive Keys.64.wav", 512);
  sample[30] = minim.loadFile("jamie 16-Addictive Keys.64.wav", 512);  
  sample[29] = minim.loadFile("jamie 15-Addictive Keys.64.wav", 512);
  sample[28] = minim.loadFile("jamie 15-Addictive Keys.64.wav", 512);
  sample[27] = minim.loadFile("jamie 14-Addictive Keys.64.wav", 512);
  sample[26] = minim.loadFile("jamie 14-Addictive Keys.64.wav", 512);  
  sample[25] = minim.loadFile("jamie 13-Addictive Keys.64.wav", 512);
  sample[24] = minim.loadFile("jamie 13-Addictive Keys.64.wav", 512);
  sample[23] = minim.loadFile("jamie 10-Addictive Keys.64.wav", 512);
  sample[22] = minim.loadFile("jamie 10-Addictive Keys.64.wav", 512);
  sample[21] = minim.loadFile("jamie 11-Addictive Keys.64.wav", 512);
  sample[20] = minim.loadFile("jamie 11-Addictive Keys.64.wav", 512);
  sample[19] = minim.loadFile("jamie 12-Addictive Keys.64.wav", 512);
  sample[18] = minim.loadFile("jamie 12-Addictive Keys.64.wav", 512);
  sample[17] = minim.loadFile("jamie 13-Addictive Keys.64.wav", 512);
  sample[16] = minim.loadFile("jamie 13-Addictive Keys.64.wav", 512);
  sample[15] = minim.loadFile("jamie 14-Addictive Keys.64.wav", 512);  
  sample[14] = minim.loadFile("jamie 14-Addictive Keys.64.wav", 512);
  sample[13] = minim.loadFile("jamie 15-Addictive Keys.64.wav", 512);
  sample[12] = minim.loadFile("jamie 15-Addictive Keys.64.wav", 512);
  sample[11] = minim.loadFile("jamie 16-Addictive Keys.64.wav", 512);  
  sample[10] = minim.loadFile("jamie 16-Addictive Keys.64.wav", 512);
  sample[9] = minim.loadFile("jamie 17-Addictive Keys.64.wav", 512);
  sample[8] = minim.loadFile("jamie 17-Addictive Keys.64.wav", 512);
  sample[7] = minim.loadFile("jamie 18-Addictive Keys.64.wav", 512);
  sample[6] = minim.loadFile("jamie 18-Addictive Keys.64.wav", 512);
  sample[5] = minim.loadFile("jamie 19-Addictive Keys.64.wav", 512);
  sample[4] = minim.loadFile("jamie 19-Addictive Keys.64.wav", 512);
  sample[3] = minim.loadFile("jamie 20-Addictive Keys.64.wav", 512);
  sample[2] = minim.loadFile("jamie 20-Addictive Keys.64.wav", 512);
  sample[1] = minim.loadFile("jamie 21-Addictive Keys.64.wav", 512);
  sample[0] = minim.loadFile("jamie 21-Addictive Keys.64.wav", 512);  



  audio = new Audio[numSamples];
  vis = new Visualization[numSamples];

  /////////////////// set up x and y positions for the grid //////////////////

  int y = 0;
  int x = 0;
  int z =0;
  while (y < numSamples) {
    xpos[y] = (x*width/numCols) + (width/numCols/2);
    ypos[y] = (z*height/numRows)+ (height/numRows/2);
    y++;
    x++;
    if (y%numCols==0) {
      z++;
    }
    if (x > numRows) {
      x = 0;
    }
  }

  ///////////////populate audio and vis arrays////////////////
  for (int i = 0; i < numSamples; i++) {
    audio[i] = new Audio(true, 0, sample[i].length(), sample[i]);
    vis[i] = new Visualization(xpos[i], ypos[i]);

    ///////set samples in audio to sample array/////////////
    audio[i].setSample(sample[i]);
  }

  for (int i=0; i< numSamples; i++) {
    //////////////////////loop all tracks/////////////////////////////

    audio[i].getSample().loop();
    /////////////////////mute all tracks to start//////////////////

    audio[i].getSample().mute();

    //////////////////////populate fft array//////////////////
    fft[i] = new FFT(audio[i].getSample().bufferSize(), audio[i].getSample().sampleRate() );
  }

  String[] cameras = Capture.list();

  ////////////////////camera + optical flow setup////////////////////////
  if (cameras.length == 0) {
    println("There are no cameras available for capture. Exiting application");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    Capture cam = new Capture(this, width, height, cameras[0]);
    cam.start();
    SOF = new ShimodairaOpticalFlow(cam);
  }
}

void draw () {  

  // def put this in setup 
  for (int i=0; i< numSamples; i++) {
    fft[i].forward( audio[i].getSample().mix );
    area_sum [i] =0;
  }

  ///////////////////////set volume of each track to each diameter/////////////////////////

  int index=0;
  while (index<numSamples) {
    for (int i = 0; i < fft[0].specSize(); i++)
    {
      diameter[index] = fft[index].getBand(i)*1000;
    }
    index++;
  }

  ////////////////////////// optical flow///////////////////////////////////
  if (SOF.flagimage) set(0, 0, SOF.cam);
  else background(0);
  filter(THRESHOLD);
  filter(INVERT);
  fill(0,0,0,90);
  rect(0,0,1440,840);



  // calculate optical flow
  SOF.calculateFlow(); 

  // draw the optical flow vectors
  if (SOF.flagflow)
    SOF.drawFlow();

  for (int i = 0; i < SOF.flows.size() - 2; i+=2) {
    PVector force_start = SOF.flows.get(i);
    PVector force_end = SOF.flows.get(i+1);
    PVector force = PVector.sub (force_end, force_start);
    float force_mag = force.mag()*0.1;

    ///////////calculate sum of vectors in specific areas////////////////

    for (int x =0; x<numSamples; x++) {
      vis[x].sumArea(force_start, force_mag, x);
    }
  }

  for (int i =0; i<numSamples; i++) {
    /////////// draw visualization with samples if moving in that area /////////////////
    if (audio[i].getPlay_track(area_sum[i])) {
      vis[i].drawVis(i);

      audio[i].getSample().unmute();
    } else {
      audio[i].stopTrack();
    }
  }

  ///////////////////////set up base grid of ellipses/////////////////////////
  for (int i =0; i<numSamples; i++) {
    vis[i].setupGrid();
  }
}