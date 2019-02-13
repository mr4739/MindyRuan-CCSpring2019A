/*
pong.pde
Author: Mindy Ruan
Summary: (Janky) Pong
- Single Player, mouse controlled (You always lose, but you also always win)
- Uses only what's been covered in class, but has some problems
- Ideally should be 2-player, but keyboard input has slight delay, so opted
  for mouse control instead 
- Collision is janky, ball colliding with paddle at the top/bottom is weird

CONTROLS:
*** MOUSE - control paddle positions with mouse position
*** SPACE - start ball
*** R - reset ball (will not reset scores)
*/

float ballX, ballY;
float velX = 0, velY = 0;
int p1Score = 0, p2Score = 0;

void setup() {
  size(1280, 800);
  ballX = width/2;
  ballY = height/2;
  noStroke();
}

void draw() {
  background(0);
  // Ball
  ellipse(ballX, ballY, 20, 20);
  // Paddles
  rectMode(CENTER);
  rect(width/10, mouseY, 20, 80);      // Paddle 1
  rect(9* width/10, mouseY, 20, 80);   // Paddle 2  
  // Score printing
  textAlign(CENTER);
  textSize(30);
  text("P1 Score: " + p1Score, width/5, 50);
  text("P2 Score: " + p2Score, 4 * width/5, 50);
  
  // If ball reaches left edge, P2 gets point, reset ball in middle
  if (ballX <= 10) { 
    velX = 0;
    velY = 0;
    p2Score++;
    ballX = width/2;
    ballY = height/2;
  }
  // If ball reaches right edge, P1 gets point, reset ball in middle
  if (ballX >= width-10) {
    velX = 0;
    velY = 0;
    p1Score++;
    ballX = width/2;
    ballY = height/2;
  }
  // If ball hits top/bottom edge, reverse direction
  if (ballY <= 10 || ballY >= height-10) velY *= -1;
  // Update ball position
  ballX += velX;
  ballY += velY;
  // Reverse X direction if ball hits paddle 1
  if (ballX <= width/10 + 20 && ballX >= width/10 - 20) {
    if (ballY >= mouseY - 40 && ballY <= mouseY + 40) {
      velX *= -1;
    }
  }
  // Reverse X direction if ball hits paddle 2
  if (ballX >= 9* width/10 - 20 && ballX <= 9* width/10 + 20) {
    if (ballY >= mouseY - 40 && ballY <= mouseY + 40) {
      velX *= -1;
    }
  }
}

void keyPressed() {
  // R to reset ball in middle
  if (key == 'r' || key == 'R') {
    ballX = width/2;
    ballY = height/2;
    velX = 0;
    velY = 0;
  }
  // SPACE to start ball
  if (key == ' ' && velX == 0 && velY == 0) {
    velX = 5.0;
    velY = 5.0;
  }
}
