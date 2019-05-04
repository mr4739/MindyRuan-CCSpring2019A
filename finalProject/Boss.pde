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
  
  public void display() {
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, size, size);
  }
}
