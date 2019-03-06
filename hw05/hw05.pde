/*
hw05.pde
Author: Mindy Ruan
Summary: 3 bouncy lads going on a trip
*/

Lad[] lads = new Lad[3];
// for scrolling terrains
float offset, offset2;

void setup() {
  size(1200, 800);
  noStroke();
  rectMode(CENTER);
  frameRate(60);
  // Add 3 Lads to the squad
  lads[0] = new Lad(0, 200, 130, 120, 0);
  lads[1] = new Lad(300, 175, 180, 170, 5);
  lads[2] = new Lad(-300, 175, 180, 170, 3);
}

void draw() {
  // Purple background
  background(#B24085);
  
  // Scrolling terrains in background
  for (int i = 0; i < width; i++) {
    // Pink terrain
    stroke(#FF76C8);
    line(i, height, i, height - noise((i+offset)*0.01) * 500);
    // Teal terrain in front of pink, scrolls faster
    stroke(#4AC3CC);
    line(i, height, i, height - noise((i+offset2)*0.01) * 300);
  }
  offset += 3;
  offset2 += 12;
  
  // Ground - Teal rectangle
  noStroke();
  fill(#4AC3CC);
  rect(width/2, height, width, 320);
  
  // Animate the lads
  for (int i = 0; i < lads.length; i++) {
    lads[i].animate();
  }
}
