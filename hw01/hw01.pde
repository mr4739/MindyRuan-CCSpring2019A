/*
hw01.pde
Homework #1
Author: Mindy Ruan
Summary: Recreated piece of art by Mario Carreno found below
https://artsandculture.google.com/asset/untitled/KgGv7jz6YWO86g
*/

void setup() {
  size(960, 730);
  
  // Green background
  background(90, 157, 77);
  noStroke();
  
  // Dark green rectangles
  fill(57, 123, 85);
  rect(140, 0, 430, 230);
  rect(0, 65, 230, 85);
  rect(300, 65, 490, 305);
  rect(370, 670, 300, 200);
  
  // Darker green rectagles
  fill(35, 73, 82);
  rect(140, 65, 90, 90);
  rect(300, 150, 90, 80);
  rect(570, 65, 100, 90);
  rect(670, 155, 120, 220);
  rect(0, 300, 200, 250);
  rect(0, 550, 150, 200);
  rect(875, 370, 100, 370);
  
  // Green rectangle
  fill(90, 157, 77);
  rect(875, 450, 50, 220);
  
  // Lime Green rectangles
  fill(173, 190, 13);
  rect(230, 0, 140, 150);
  rect(0, 150, 230, 150);
  rect(790, 0, 180, 370);
  rect(40, 370, 190, 300);
  rect(615, 620, 265, 280);
  
  // Yellow rectangles
  fill(202, 195, 78);
  rect(370, 65, 200, 305);
  rect(230, 370, 140, 370);
  rect(615, 370, 265, 260);
  
  // Transparent Red triangles
  fill(111, 32, 51, 200);
  triangle(155, 225, 105, 600, 205, 600);
  triangle(300, 600, 260, 450, 340, 450);
  triangle(300, 520, 260, 670, 340, 670);
  triangle(440, 190, 440, 510, 530, 510);
  triangle(530, 240, 440, 510, 530, 510);
  triangle(570, 370, 570, 510, 530, 510);
  triangle(530, 510, 570, 690, 530, 690);
  triangle(530, 510, 570, 690, 490, 690);
  triangle(830, 65, 920, 65, 875, 280);
  triangle(830, 340, 920, 340, 875, 200);
  triangle(747, 510, 687, 600, 807, 600);
  triangle(155, 550, 105, 600, 205, 600);
  triangle(747, 510, 687, 600, 747, 600);
  
  // Red Checkered Diamonds
  quad(687, 460, 747, 510, 807, 460, 747, 410);
  quad(687, 460, 807, 460, 747, 510, 747, 410);
  quad(440, 190, 380, 150, 440, 110, 500, 150);
  quad(440, 190, 440, 110, 380, 150, 500, 150);
  
  // Red Arcs
  noFill();
  stroke(111, 32, 51);
  strokeWeight(15);
  arc(155, 125, 180, 200, QUARTER_PI, PI- QUARTER_PI);
  arc(300, 460, 200, 200, QUARTER_PI, PI- QUARTER_PI);
  
  // Lime Green Arc
  stroke(173, 190, 13);
  arc(680, 215, 240, 220, QUARTER_PI, PI- QUARTER_PI);
  
  // Green lines
  stroke(90, 157, 77);
  strokeWeight(2);
  line(635, 630, 635, 730);
  line(655, 630, 655, 730);
  line(675, 630, 675, 730);
  line(695, 630, 695, 730);
  line(715, 630, 715, 730);
  line(735, 630, 735, 730);
  line(755, 630, 755, 730);
  line(775, 630, 775, 730);
  line(795, 630, 795, 730);
  line(815, 630, 815, 730);
  line(835, 630, 835, 730);
  line(855, 630, 855, 730);
  
}

void draw() {
  
}
