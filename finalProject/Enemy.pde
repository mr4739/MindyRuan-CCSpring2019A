/*
Possibly a base class, second enemy class can inherit from this one
*/

class Enemy {
  public int hp = 50;
  public int dmg = 10;
  public float speed = 1.5;
  public PVector vel = new PVector(1.0, 1.0);
  public PVector pos = new PVector(width/2, height/2);
  public Hitbox hitbox = new Hitbox(width/2, height/2, 40, 40);
  
  // reposition if pos circle-collides with radius around entrance
  // circle-circle collision
  // if distance btwn centers < sum of radii
  // dist = sqrt(x^2 + y^2)
  public Enemy(float roomW, float roomH, float entranceX, float entranceY) {
    pos.x = random(width/2 - roomW/2 + 40, width/2 + roomW/2 - 40);
    pos.y = random(height/2 - roomH/2 + 40, height/2 + roomH/2 - 40);
    while (dist(pos.x, pos.y, entranceX, entranceY) <= 250) {
      pos.x = random(width/2 - roomW/2 + 40, width/2 + roomW/2 - 40);
      pos.y = random(height/2 - roomH/2 + 40, height/2 + roomH/2 - 40);
    }
    hitbox.x = pos.x;
    hitbox.y = pos.y;
  }
  
  public void display() {
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, 40, 40);
    hitbox.display();
  }
  
  public void chase() {
    PVector dir = PVector.sub(player.pos, pos);
    dir.x = (dir.x > 0) ? 1 : -1;
    dir.y = (dir.y > 0) ? 1 : -1;
    pos.x += dir.x * speed;
    pos.y += dir.y * speed;
    hitbox.x = pos.x;
    hitbox.y = pos.y;
    // move this to main?
    //if (player.hitbox.isColliding(hitbox)) {
    //  player.hp -= 1;
    //  // trigger invincibility
    //}
  }
}
