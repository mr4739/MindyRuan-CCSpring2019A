class Boss extends Enemy {
  public int divisions = 0;
  public float size = 30;
  
  public Boss(int divs) {
    super(width/2, height/2, divs * 30);
    divisions = divs;
    size = divs * 30;
    hp = 50 * divisions;
    speed = 1.5 / divisions;
  }
  
  public Boss(Boss other) {
    super(other.pos.x, other.pos.y, other.size);
    other.pos.x -= 2*size;
    pos.x += 2*size;
    divisions = other.divisions;
    size = divisions * 30;
    hp = 50 * divisions;
    speed = 1.5 / divisions;
  }
  
  public void display() {
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, size, size);
  }
  
  public void loseHP(int amt) {
    hp -= amt;
    divisions--;
    size = divisions * 30;
    hitbox.w = size;
    hitbox.h = size;
    speed = 1.5 / divisions;
  }
}
