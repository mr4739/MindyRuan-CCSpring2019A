/*
hw02_sol2.pde
Homework #2
Author: Mindy Ruan
Summary: Solving Sol- Wall Drawing #630 (1990)
A wall is divided horizontally into two equal parts. 
Top: alternating horizontal black and white 8-inch (20 cm) bands. 
Bottom: alternating vertical black and white 8-inch (20 cm) bands.
http://solvingsol.com/
*/

void setup() {
  size(840, 840);
  background(255);
  
  strokeCap(PROJECT);
  strokeWeight(10);
  stroke(0);
  
  // Black horizontal bands across top half
  for (int i = 0; i < height/40; i++) {
    line(0, 10 + i*20, width, 10 + i*20);
  }
  // Black vertical bands across bottom half
  for (int i = 0; i < width/20; i++) {
    line(10 + i*20, height/2, 10 + i*20, height);
  }
  
}

void draw() {
  
}
