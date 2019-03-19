/*
midterm.pde
Author: Mindy Ruan
Summary: Brick Breaker

CONTROLS:
*** LEFT/RIGHT - move paddle
*** R - restart game
*** SPACE - toggle pause/start game
*** W - insta-win (cheat)
*/

ArrayList<Brick> bricks = new ArrayList<Brick>();
Ball ball;
float pX;                // paddle's X position
float pVel = 8;          // paddle's velocity
boolean isLeft, isRight; // flags for if LEFT/RIGHT is held down
boolean paused = true;
boolean showWin, showLose;
int score;
int lives = 3;

void setup() {
  size(800, 1000);
  rectMode(CENTER);
  textAlign(CENTER);
  textSize(32);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  pX = width/2;
  // Fill up bricks arraylist; 8x8 grid
  for (int j = 0; j < 8; j++) {
    for (int i = 0; i < 8; i++) {
      bricks.add(new Brick(50+i*100, 25+j*50));
    }
  }
  ball = new Ball(new PVector(width/2, height-90));
}

void draw() {
  // If game still in progress
  if (!showWin && !showLose) {
    background(0);
    fill(360, 0, 100); // white
    // Display current score and lives count at bottom of screen
    text("Score: " + score, width/2+200, height-20);
    text("Lives: " + lives, width/2-200, height-20);
    
    // Draw everything
    ball.display();
    rect(pX, height-70, 100, 10);
    for (int i = 0; i < bricks.size(); i++) {
      bricks.get(i).display();
    }
    
    // If game isn't paused, update ball and paddle positions
    if (!paused) {
      // If ball collides with a brick, add 100 to score
      if (ball.update(bricks)) score += 100;
      paddleUpdate();
    }
    
    // If ball reaches bottom of screen, 
    // lose a life, reset ball and paddle positions
    if (ball.pos.y >= height) {
      lives--;
      reset();
    }
  }
  
  // If bricks arraylist is empty, win
  if (bricks.size() == 0) {
    showWin = true;
  }
  // If player has no more lives, lose
  if (lives == 0) showLose = true;
  // Show win screen
  if (showWin) win();
  if (showLose) lose();
}

// Update paddle position
void paddleUpdate() {
  pX += pVel * (int(isRight) - int(isLeft));
  // Limit pX within bounds of the screen
  pX = constrain(pX, 50, width-50);
  
  // If ball collides with top/bottom of paddle, reverse y direction
  if (ball.pos.y+15 + ball.vel.y/2 >= height-70
      && ball.pos.y-15 + ball.vel.y/2 <= height-65
      && ball.pos.x+15 >= pX-50 
      && ball.pos.x-15 <= pX+50) {
    ball.vel.y *= -1;
    // set ball's X velocity depending on ball's location relative to paddle
    float vX = map(ball.pos.x, pX-50, pX+50, -3.0, 3.0);
    ball.vel.x = vX;
  }
  // If ball collides with left/right of paddle, reverse x direction
  if (ball.pos.y+15 >= height-70
      && ball.pos.y-15 <= height-65
      && ball.pos.x+15 + ball.vel.x/2 >= pX-50 
      && ball.pos.x-15 + ball.vel.x/2 <= pX+50) {
    ball.vel.x *= -1;
    // set ball's X velocity depending on ball's location relative to paddle
    float vX = map(ball.pos.x, pX-50, pX+50, -3.0, 3.0);
    ball.vel.x = vX;
  }
}

// Reset game
void reset() {
  // Reset ball position
  ball.pos.x = width/2;
  ball.pos.y = height-90;
  // Reset ball velocity
  ball.vel.y = -5;
  ball.vel.x = 0;
  // Reset paddle position
  pX = width/2;
  // Game paused until player unpauses
  paused = true;
  // If reset at win screen, do all of the above
  // And reset lives, score, bricks, win flag
  if (showWin || showLose) {
    lives = 3;
    score = 0;
    bricks.clear();
    for (int j = 0; j < 8; j++) {
      for (int i = 0; i < 8; i++) {
        bricks.add(new Brick(50+i*100, 25+j*50));
      }
    }
    showWin = false;
    showLose = false;
  }
}

// Draw win screen
void win() {
  background(0);
  text("You won!", width/2, height/2-30);
  text("Score: " + score, width/2, height/2);
  text("Press R to restart", width/2, height/2 + 60);
}

// Draw game over screen
void lose() {
  background(0);
  text("Game over!", width/2, height/2-30);
  text("Score: " + score, width/2, height/2);
  text("Press R to restart", width/2, height/2 + 60);
}

// LEFT/RIGHT - set respective flags
// R - reset
// SPACE - toggle pause
// W - insta-win
void keyPressed() {
  if (keyCode == LEFT) isLeft = true;
  if (keyCode == RIGHT) isRight = true;
  if (keyCode == 'r' || keyCode == 'R') {
    reset();
    lives = 3;
    score = 0;
  }
  if (keyCode == ' ') paused = !paused;
  if (keyCode == 'w' || keyCode == 'W') showWin = true;
}

// If LEFT/RIGHT released, set flags to false
void keyReleased() {
  if (keyCode == LEFT) isLeft = false;
  if (keyCode == RIGHT) isRight = false;
}
