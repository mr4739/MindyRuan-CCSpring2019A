class Brick {
  public PVector pos;
  public PVector size = new PVector(100, 50);
  // Initialize with random color
  public color c = color(random(0, 360), random(0, 50), random(50, 100));
  
  public Brick() {}
  // float x: x-position of brick
  // float y: y-position of brick
  public Brick(float x, float y) {
    pos = new PVector(x, y);
  }
  
  // Draw brick
  public void display() {
    fill(c);
    rect(pos.x, pos.y, size.x, size.y);
  }
}
