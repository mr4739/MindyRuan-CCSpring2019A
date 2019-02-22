/*
hw04.pde
Author: Mindy Ruan
Summary: Rings of squares spinning about the center in 
alternating directions and colors. Colors change based on
mouseX and mouseY values.

CONTROLS:
*** SPACE - reverse spin directions
*/

color c1;
color c2;
float rectSize = 50;
int direction = 1;

void setup() {
  size(950, 950);
  noStroke();
  rectMode(CENTER);
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  // Set hue and saturation of c1 based on mouse position
  float hue = map(mouseX, 0, width, 0, 360);
  float sat = map(mouseY, 0, height, 0, 100);
  color c1 = color(hue, sat, 100);
  // Set c2 to a triadic color of c1
  color c2 = color((hue(c1)+120)%360, sat, 100);
  // Set background color to other triadic of c1
  background(color((hue(c1)+240)%360, sat, 100));
  
  // translate center of screen to (0, 0)
  translate(width/2, height/2);
  
  // draw square in center rotating clockwise
  fill(c1);
  pushMatrix();
  rotate(direction * radians(frameCount % 360));
  rect(0, 0, rectSize, rectSize);
  popMatrix();
  
  // draw ring of 4 squares rotating counter-clockwise
  // 4 squares, radius 75 from origin, 1/2 original size
  fill(c2);
  pushMatrix();
  rotate(-direction * radians(frameCount % 360));
  drawRing(4, 75, rectSize/2);
  popMatrix();
  
  // draw ring of 8 squares rotating clockwise
  // 8 squares, radius 150 from origin, 1/3 original size
  fill(c1);
  pushMatrix();
  rotate(direction * radians(frameCount % 360));
  drawRing(8, 150, rectSize/3);
  popMatrix();
  
  // draw ring of 16 squares rotating clockwise
  // 16 squares, radius 225 from origin, 1/4 original size
  fill(c2);
  pushMatrix();
  rotate(-direction * radians(frameCount % 360));
  drawRing(16, 225, rectSize/4);
  popMatrix();
  
  // draw ring of 32 squares rotating clockwise
  // 32 squares, radius 300 from origin, 1/5 original size
  fill(c1);
  pushMatrix();
  rotate(direction * radians(frameCount % 360));
  drawRing(32, 300, rectSize/5);
  popMatrix();
  
  // draw ring of 64 squares rotating clockwise
  // 64 squares, radius 375 from origin, 1/6 original size
  fill(c2);
  pushMatrix();
  rotate(-direction * radians(frameCount % 360));
  drawRing(64, 375, rectSize/6);
  popMatrix();
  
  // draw ring of 128 squares rotating clockwise
  // 128 squares, radius 450 from origin, 1/7 original size
  fill(c1);
  pushMatrix();
  rotate(direction * radians(frameCount % 360));
  drawRing(128, 450, rectSize/7);
  popMatrix();
}

// Draws ring of squares
// int numSquares: number of squares in the ring
// float radius: radius of the ring from origin
// float size: size of each square
void drawRing(int numSquares, float radius, float size) {
  for (int i = 0; i < numSquares; i++) {
    // x = rcos(theta)
    float x = radius * cos(radians(360/numSquares + i*360/numSquares));
    // y = rsin(theta)
    float y = radius * sin(radians(360/numSquares + i*360/numSquares));
    rect(x, y, size, size);
  }
}

// SPACE to reverse spin directions
void keyPressed() {
  if (key == ' ') direction *= -1;
}
