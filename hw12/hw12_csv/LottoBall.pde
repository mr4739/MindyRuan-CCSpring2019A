class LottoBall {
  float x, y;       // x, y positions of the ball
  float rad;        // radius of ball
  String ballNum;   // ball number (value in key, value pair)
  float speed;      // ball's speed
  int xDir = 1; int yDir = -1;  // x, y movement directions
  color c = color(0, 77, 100);  // red
  
  // LottoBall constructor
  // float x, y: starting position
  // float rad: radius
  // String ballNum: ball number
  public LottoBall(float x, float y, float rad, String ballNum) {
    this.x = x;
    this.y = y;
    this.rad = rad;
    this.ballNum = ballNum;
    xDir = floor(random(0, 2)) == 0? -1 : 1;
    yDir = floor(random(0, 2)) == 0? -1 : 1;
    // Speed mapped using radius (which was mapped using freq number)
    speed = map(rad, 40, 300, 1, 25);
    // Red, but saturation, brightness, and alpha are mapped by radius (which was mapped using freq number)
    c = color(0, map(rad, 40, 300, 10, 100), map(rad, 40, 300, 10, 100), map(rad, 40, 300, 50, 100));
  }
  
  public void display() {
    // Red circle
    fill(c);
    circle(x, y, rad);
    // white text, alpha same as circle's color alpha
    // draw text in the middle of the ball
    fill(0, 0, alpha(c));
    textSize(rad/2);
    text(ballNum, x, y);
  }
  
  public void update() {
    // Reverse directions when edges reached
    if (x < 0 || x > width) xDir *= -1;
    if (y < 0 || y > height) yDir *= -1;
    // Update positions
    x += speed * xDir;
    y += speed * yDir;
  }
}
