class ProjectileEnemy extends Enemy {
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  
  public ProjectileEnemy(float roomW, float roomH, float entranceX, float entranceY) {
    super(roomW, roomH, entranceX, entranceY);
    hitbox.w = 50;
    hitbox.h = 50;
    speed = 0;
    hp = 100;
  }
  
  public void display() {
    fill(0, 0, 255);
    ellipse(pos.x, pos.y, 50, 50);
    hitbox.display();
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).display();
      bullets.get(i).hitbox.display();
    }
  }
  
  public void update() {
    if (frameCount % 30 == 0) { 
      bullets.add(new Bullet(pos.x, pos.y));
      shoot.play();
    }
    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = bullets.get(i);
      b.update();
      if (b.pos.x >= width/2 + currentRoom.w/2 || b.pos.x <= width/2 - currentRoom.w/2 ||
          b.pos.y >= height/2 + currentRoom.h/2 || b.pos.y <= height/2 - currentRoom.h/2) bullets.remove(i);
      if (!isInvincible && b.hitbox.isColliding(player.hitbox)) {
        player.hp -= 5;
        isInvincible = true;
        invincStart = millis();
        player.speed = 7.0;
        bullets.remove(i);
      }
    }
  }
  
}
