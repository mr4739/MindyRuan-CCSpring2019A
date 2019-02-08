/*
hw02_sol1.pde
Homework #2
Author: Mindy Ruan
Summary: Solving Sol- Wall Drawing #87 (1971)
A square divided horizontally and vertically into four equal parts, 
each with lines and colors in four directions superimposed progressively.
http://solvingsol.com/
*/

void setup() {
  size(840, 840);
  background(255);
  
  // Vertical lines (entire canvas)
  stroke(0, 0 , 255);
  for (int i = 0; i < 28; i++) {
    line(i*30, 0, i*30, height); 
  }
  // Horizontal lines: Top Right Quadrant
  stroke(255, 0, 0);
  for (int i = 0; i < 14; i++) {
    line(width/2, i*30, width, i*30);
  }
  // Horizontal lines: Bottom half
  for (int i = 0; i < 14; i++) {
    line(0, height/2 + i*30, width, height/2 + i*30);
  }
  // Diagonal lines (up to right): Bottom half
  stroke(0, 255, 0);
  for (int i = 1; i < 42; i++) {
    line(i*30, height/2, 0, height/2 + i*30);
  }
  // Diagonal lines (down to right): Bottom Right Quadrant
  stroke(255, 0, 255);
  for (int i = 0; i < 14; i++) {
    line(width/2 + i*30, height/2, width, height - i*30);
    line(width/2 + i*30, height, width/2, height - i*30);
  }
  
}

void draw() {
  
}
