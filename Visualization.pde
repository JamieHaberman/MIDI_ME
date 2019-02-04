
class Visualization {

  float xpos;
  float ypos;

/////visualization constructor

  Visualization(float temp_xpos, float temp_ypos) { 
    xpos=temp_xpos;
    ypos = temp_ypos;
  }



  /////////set up base grid of ellipses
  void setupGrid() {

    noStroke();
    ellipse(xpos, ypos, 5, 5);
  }

  /////////// draw visualization
  void drawVis(int index) {
    //fill(0,231,147,80);
    //stroke(#00e793);
    noStroke();
    colorMode(HSB, 100);
    float g = map(xpos/50, -20, 20, 0, 255);
    float b = map(xpos/100, -20, 20, 0, 255);
    fill(xpos/10, 100, 100);
    ellipse(xpos, ypos, diameter[index]/.5, diameter[index]/.5);
  }

  ///////////calculate sum of vectors in specific areas
  void sumArea(PVector force_start, float force_mag, int index) {
    if ((force_start.x > xpos-25 && force_start.x < 50+xpos) &&
      (force_start.y > ypos-25 && force_start.y < 50+ypos)) {
      area_sum[index] += force_mag;
    }
  }
}