/*
ProjectileEnemy
- does not move
- shoots bullet at player every 30 frames
*/

class ProjectileEnemy extends Enemy {
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();  // Array of active bullets
  
  // ProjectileEnemy constructor
  // float roomW, roomH: room size
  // float entranceX, entranceY: entrance position
  public ProjectileEnemy(float roomW, float roomH, float entranceX, float entranceY) {
    super(roomW, roomH, entranceX, entranceY);
    hitbox.w = 50;
    hitbox.h = 50;
    speed = 0;  // don't move
    hp = 100;   // more hp
  }
  
  // Draw ProjectileEnemy
  public void display() {
    fill(0, 0, 255);
    ellipse(pos.x, pos.y, 50, 50);
    //hitbox.display();
    // Draw all active bullets
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).display();
      //bullets.get(i).hitbox.display();
    }
  }
  
  // Update bullets, shooting, hit check
  public void update() {
    // Shoot bullet every 30 frames
    if (frameCount % 30 == 0) { 
      bullets.add(new Bullet(pos.x, pos.y));
      shoot.play();
    }
    for (int i = 0; i < bullets.size(); i++) {
      // Update position
      Bullet b = bullets.get(i);
      b.update();
      // Remove if bullet reaches wall
      if (b.pos.x >= width/2 + currentRoom.w/2 || b.pos.x <= width/2 - currentRoom.w/2 ||
          b.pos.y >= height/2 + currentRoom.h/2 || b.pos.y <= height/2 - currentRoom.h/2) bullets.remove(i);
      // If not invincible and hits player
      if (!isInvincible && b.hitbox.isColliding(player.hitbox)) {
        // take damage, trigger invincibility, remove bullet
        player.hp -= 5;
        isInvincible = true;
        invincStart = millis();
        player.speed = 7.0;
        bullets.remove(i);
      }
    }
  }
}
