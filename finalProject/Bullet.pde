// ProjectileEnemy's bullets

class Bullet {
  public PVector pos, dir;    // bullet's position and direction
  public float speed = 1.5;   // bullet speed
  public Hitbox hitbox;       // bullet's hitbox
  
  // Bullet constructor
  // float enemyX, enemyY: ProjectileEnemy's position
  public Bullet(float enemyX, float enemyY) {
    pos = new PVector(enemyX, enemyY);
    hitbox = new Hitbox(pos.x, pos.y, 10, 10);
    // Calculate direction vector from enemy to player
    dir = new PVector(player.pos.x - enemyX, player.pos.y - enemyY).normalize();
    dir.mult(speed);
  }
  
  // Updates bullet position
  public void update() {
    pos.x += dir.x * speed;
    pos.y += dir.y * speed;
    hitbox.x = pos.x;
    hitbox.y = pos.y;
  }
  
  // Draw bullet
  public void display() {
    fill(0, 0, 255);
    ellipse(pos.x, pos.y, 10, 10);
  }
}
