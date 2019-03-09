/*
hw06.pde
Author: Mindy Ruan
Summary: Pong v3
- 2 player, less janky collision, smoother paddle controls
- Particle effects on collision

CONTROLS:
*** W/S - move player 1 paddle up/down
*** UP/DOWN - move player 2 paddle up/down
*** SPACE - toggle pause, start game
*** R - reset game
*** T - spawn new ball
*/

ArrayList<Ball> balls = new ArrayList<Ball>();
float p1Y, p2Y;                  // Paddle 1 & 2 y-positions
float p1Vel = 6, p2Vel = 6;      // Paddle velocities
int p1Score = 0, p2Score = 0;
boolean paused = true;
// Flags to indicate if up/down controls are held down
// up1, down1 for paddle 1, others for paddle 2
boolean up1, down1, up2, down2;

void setup() {
  size(1280, 800);
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER);
  textSize(30);
  // starting ball in middle, paddles in middle
  balls.add(new Ball(new PVector(-5,5)));
  p1Y = height/2;
  p2Y = height/2;
}

void draw() {
  background(0);
  
  // Drawing balls
  for (int i = 0; i< balls.size(); i++) {
    // If game isn't paused, update positions
    if (!paused) balls.get(i).update(p1Y, p2Y);
    
    // If ball reaches left edge, P2 gets point, reset ball
    if (balls.get(i).pos.x <= 10) {
      balls.get(i).reset(1);
      p2Score++;
    // If ball reaches right edge, P1 gets point, reset ball
    } else if (balls.get(i).pos.x >= width-10) {
      balls.get(i).reset(-1);
      p1Score++;
    }
    balls.get(i).display();
  }
  
  // Update paddle positions based on up/down flags
  p1Y += p1Vel * (int(down1)-int(up1));
  p2Y += p2Vel * (int(down2)-int(up2));
  
  // Draw both paddles
  fill(255);
  rect(width/10, p1Y, 20, 80);      // Paddle 1
  rect(9* width/10, p2Y, 20, 80);   // Paddle 2
  
  // Score printing
  text("P1 Score: " + p1Score, width/5, 50);
  text("P2 Score: " + p2Score, 4 * width/5, 50);
}

void keyPressed() {
  // R to reset game and scores
  if (key == 'r' || key == 'R') {
    p1Score = 0;
    p2Score = 0;
    p1Y = height/2;
    p2Y = height/2;
    paused = true;
    // Clear arraylist and add new ball
    balls.clear();
    balls.add(new Ball(new PVector(5, 5)));
  }
  // SPACE to pause/unpause game
  if (key == ' ') {
    paused = !paused;
  }
  // T to spawn new ball
  if (key == 't' || key == 'T') {
    balls.add(new Ball(new PVector(random(-5, 5), random(-5, 5))));
  }
  
  // W/S player 1
  if (key == 'w' || key == 'W') up1 = true;
  if (key == 's' || key == 'S') down1 = true;
  
  // UP/DOWN player 2
  if (keyCode == UP) up2 = true;
  if (keyCode == DOWN) down2 = true;
}

void keyReleased() {
  // W/S released, set paddle 1 up/down to false
  if (key == 'w' || key == 'W') up1 = false;
  if (key == 's' || key == 'S') down1 = false;
  
  // UP/DOWN released, set paddle 2 up/down to false
  if (keyCode == UP) up2 = false;
  if (keyCode == DOWN) down2 = false;
}
