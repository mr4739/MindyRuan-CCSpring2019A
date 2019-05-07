/*
Basic Enemy class
- follows the player
*/

class Enemy {
  public int hp = 50;        // HP left
  public float speed = 1.5;  // movement speed
  public PVector vel = new PVector(1.0, 1.0);  // velocity
  public PVector pos = new PVector(width/2, height/2);  // position
  public Hitbox hitbox = new Hitbox(width/2, height/2, 40, 40);  // Enemy's hitbox
  
  // Enemy constructor
  // float roomW, roomH: this room's width, height
  // float entranceX, entranceY: position of room's entrance
  public Enemy(float roomW, float roomH, float entranceX, float entranceY) {
    // Place randomly in room
    pos.x = random(width/2 - roomW/2 + 40, width/2 + roomW/2 - 40);
    pos.y = random(height/2 - roomH/2 + 40, height/2 + roomH/2 - 40);
    // Reposition if too close to entrance
    while (dist(pos.x, pos.y, entranceX, entranceY) <= 250) {
      pos.x = random(width/2 - roomW/2 + 40, width/2 + roomW/2 - 40);
      pos.y = random(height/2 - roomH/2 + 40, height/2 + roomH/2 - 40);
    }
    hitbox.x = pos.x;
    hitbox.y = pos.y;
  }
  
  // Enemy constructor: for bosses
  // float posX, posY: position
  // float size: enemy size
  public Enemy(float posX, float posY, float size) {
    pos.x = posX;
    pos.y = posY;
    hitbox.w = size;
    hitbox.h = size;
  }
  
  // Draw enemy
  public void display() {
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, 40, 40);
    //hitbox.display();
  }
  
  // Update enemy position
  public void update() {
    // Follow player, move in player's direction
    PVector dir = PVector.sub(player.pos, pos);
    dir.x = (dir.x > 0) ? 1 : -1;
    dir.y = (dir.y > 0) ? 1 : -1;
    pos.x += dir.x * speed;
    pos.y += dir.y * speed;
    hitbox.x = pos.x;
    hitbox.y = pos.y;
  }
  
  // Lose hp by int amt
  public void loseHP(int amt) {
    hp -= amt;
  }
}
