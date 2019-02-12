/*
hw02_sol2.pde
Homework #2
Author: Mindy Ruan
Summary: Create a Processing sketch that showcases object motion within 
the bounds of the canvas and somehow incorporates user input.

CONTROLS:
*** M - toggle manual movement
*** W/A/S/D - manual movement of ellipse is manual is true
*** UP/DOWN - increase/decrease the Y radius of ellipse respectively
*** RIGHT/LEFT - increase/decrease the X radius of ellipse respectively
*/

float posX, posY; // X and Y positions of ellipse
float velX = 5.0, velY = 5.0; // X and Y velocities of ellipse
float radX = 100, radY = 100; // Sizes of ellipse X and Y radii
boolean manual = false; // Manual movement toggle

void setup() {
  size(1280, 800);
  // Start ellipse at center of canvas
  posX = width/2;
  posY = height/2;
  noStroke();
}

void draw() {
  background(0);
  ellipse(posX, posY, radX, radY);
  // If manual is false, automatically update ellipse's x and y position 
  // by velocity, and reverse direction at the canvas edges
  if (!manual) {
    if (posX >= width-radX/2 || posX <= radX/2) velX *= -1;
    if (posY >= height-radY/2 || posY <= radY/2) velY *= -1;
    posX += velX;
    posY += velY;
  }
}

// M - toggle manual movement
// WASD - manual movement
// LEFT/RIGHT - decr/incr radX
// UP/DOWN - incr/decr radY
void keyPressed() {
  // UP/DOWN/LEFT/RIGHT arrow keys to change ellipse radii sizes
  if (keyCode == 38) radY++; //UP
  if (keyCode == 40) radY--; //DOWN
  if (keyCode == 37) radX--; //LEFT
  if (keyCode == 39) radX++; //RIGHT
  // M to toggle manual movement (true or false)
  if (key == 'm' || key == 'M') {
    manual = !manual;
  }
  // If manual is true, allow WASD movement
  if (manual) {
    if (key == 'w' || key == 'W') {
      posY -= 5.0;
    }
    if (key == 'a' || key == 'A') {
      posX -= 5.0;
    }
    if (key == 's' || key == 'S') {
      posY += 5.0;
    }
    if (key == 'd' || key == 'D') {
      posX += 5.0;
    }
    // Reset the ellipse's x or y position if outside of canvas bounds
    if (posX >= width-radX/2 || posX <= radX/2) posX = width/2;
    if (posY >= height-radY/2 || posY <= radY/2) posY = height/2;
  }
}
