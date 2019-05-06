class Bullet {
  public float angle;
  public PVector pos, dir;
  public float speed = 1.5;
  public Hitbox hitbox;
  
  public Bullet(float enemyX, float enemyY) {
    pos = new PVector(enemyX, enemyY);
    hitbox = new Hitbox(pos.x, pos.y, 10, 10);
    dir = new PVector(player.pos.x - enemyX, player.pos.y - enemyY).normalize();
    dir.mult(speed);
    angle = atan2(player.pos.x - enemyX, player.pos.y - enemyY) / PI * 180;
    angle += PI/2;
  }
  
  public void update() {
    pos.x += dir.x * speed;
    pos.y += dir.y * speed;
    hitbox.x = pos.x;
    hitbox.y = pos.y;
  }
  
  public void display() {
    fill(0, 0, 255);
    ellipse(pos.x, pos.y, 10, 10);
  }
}
