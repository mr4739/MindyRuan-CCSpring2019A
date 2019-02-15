/*
hw03.pde
Author: Mindy Ruan
Summary: (Janky) Pong v2
- 2 player and janky collision
- Multiple balls can be spawned
- Ideally should use classes/objects for simplicity

CONTROLS:
*** W/S - move player 1 paddle up/down
*** UP/DOWN - move player 2 paddle up/down
*** SPACE - start ball
*** R - reset game
*** T - spawn new ball
*/

float[] ballX = new float[1];
float[] ballY = new float[1];
float[] velX = new float[1];
float[] velY = new float[1];
float p1Y, p2Y;
int p1Score = 0, p2Score = 0;
boolean paused = true;

void setup() {
  size(1280, 800);
  ballX[0] = width/2;
  ballY[0] = height/2;
  velX[0] = 5.0f;
  velY[0] = 5.0f;
  p1Y = height/2;
  p2Y = height/2;
  noStroke();
}

void draw() {
  background(0);
  // Drawing all balls with random fill colors
  for (int i = 0; i < ballX.length; i++) {
    fill(random(255), random(255), random(255));
    ellipse(ballX[i], ballY[i], 20, 20);
  }
  // White paddles
  rectMode(CENTER);
  fill(255);
  rect(width/10, p1Y, 20, 80);      // Paddle 1
  rect(9* width/10, p2Y, 20, 80);   // Paddle 2
  
  // Score printing
  textAlign(CENTER);
  textSize(30);
  text("P1 Score: " + p1Score, width/5, 50);
  text("P2 Score: " + p2Score, 4 * width/5, 50);
  
  // Update all ball positions if game isn't paused
  if (!paused) {
    for (int i = 0; i < ballX.length; i++) {
      // If ball reaches left edge, P2 gets point, 
      // reset ball in middle with random velocities
      if (ballX[i] <= 10) { 
        velX[i] = random(2.0, 5.0);
        velY[i] = random(-5.0, 5.0);
        p2Score++;
        ballX[i] = width/2;
        ballY[i] = height/2;
      }
      // If ball reaches right edge, P1 gets point, 
      // reset ball in middle with random velocities
      if (ballX[i] >= width-10) {
        velX[i] = random(-5.0, -2.0);
        velY[i] = random(-5.0, 5.0);
        p1Score++;
        ballX[i] = width/2;
        ballY[i] = height/2;
      }
      // If ball hits top/bottom edge, reverse direction
      if (ballY[i] <= 10 || ballY[i] >= height-10) velY[i] *= -1;
      // Reverse X direction if ball hits paddle 1
      if (ballX[i] <= width/10 + 20 && ballX[i] >= width/10 - 20) {
        if (ballY[i] >= p1Y - 40 && ballY[i] <= p1Y + 40) {
          velX[i] *= -1;
        }
      }
      // Reverse X direction if ball hits paddle 2
      if (ballX[i] >= 9* width/10 - 20 && ballX[i] <= 9* width/10 + 20) {
        if (ballY[i] >= p2Y - 40 && ballY[i] <= p2Y + 40) {
          velX[i] *= -1;
        }
      }
      // Update ball position
      ballX[i] += velX[i];
      ballY[i] += velY[i];
    }
  }
  
}

void keyPressed() {
  // R to reset game and scores
  if (key == 'r' || key == 'R') {
    p1Score = 0;
    p2Score = 0;
    p1Y = height/2;
    p2Y = height/2;
    // reset array lengths to hold single ball
    ballX = new float[1];
    ballY = new float[1];
    velX = new float[1];
    velY = new float[1];
    ballX[0] = width/2;
    ballY[0] = height/2;
    velX[0] = 5.0f;
    velY[0] = 5.0f;
    paused = true;
  }
  // SPACE to pause/unpause game
  if (key == ' ') {
    paused = !paused;
  }
  
  // T to spawn new ball
  if (key == 't' || key == 'T') {
    ballX = append(ballX, width/2);
    ballY = append(ballY, height/2);
    velX = append(velX, random(-5.0, 5.0));
    velY = append(velY, random(-5.0, 5.0));
  }
  
  // W/S player 1
  if (key == 'w' || key == 'W') {
    p1Y -= 30.0;
  }
  if (key == 's' || key == 'S') {
    p1Y += 30.0;
  }
  // UP/DOWN player 2
  if (keyCode == UP) {
    p2Y -= 30.0;
  }
  if (keyCode == DOWN) {
    p2Y += 30.0;
  }
}
