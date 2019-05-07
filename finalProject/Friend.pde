/*
Friends, for throwing
- start caged, player must break cage to pick up
- once in party, used as weapons
*/

class Friend {
  public PVector pos = new PVector(width/2, height/2);  // position
  public boolean isFree = false;                        // is this friend free
  public float speed = 8.0;                             // friend's movement speed
  public PVector dir = new PVector(0,0);                // movement direction
  public int w = 20;                                    // friend's width
  public Hitbox hitbox;                                 // friend's hitbox
  public int cageHP = 0;                                // Cage's hp
  
  // Friend constructor
  // PVector position, direction: self-explanatory
  // int cageHP: initial cage hp
  public Friend(PVector position, PVector direction, int cageHP) {
    pos.x = position.x;
    pos.y = position.y;
    dir.x = direction.x;
    dir.y = direction.y;
    hitbox = new Hitbox(position.x, position.y, w, w);
    this.cageHP = cageHP;
  }
  
  // Draw friend
  // float roomW, roomH: this room's width, height
  public void display(float roomW, float roomH) {
    // If direction is not 0, update friend's position
    if (dir.x != 0 || dir.y != 0) update(roomW, roomH);
    // Draw lad image
    image(smallLad, pos.x, pos.y);
    // If not free, draw cage image
    if (!isFree) image(cage, pos.x, pos.y);
    //hitbox.display();
  }
  
  // Update friend's position
  // float roomW, roomH: room's width, height
  public void update(float roomW, float roomH) {
    pos.x += speed * dir.x;
    pos.y += speed * dir.y;
    // Keep friend's within boundaries of room
    pos.x = constrain(pos.x, width/2 - roomW/2 + w/2, width/2 + roomW/2 - w/2);
    pos.y = constrain(pos.y, height/2 - roomH/2 + w/2, height/2 + roomH/2 - w/2);
    hitbox.x = pos.x;
    hitbox.y = pos.y;
    // If at room edges, set directions to 0
    if (pos.x <= width/2 - roomW/2 + w/2 || pos.x >= width/2 + roomW/2 - w/2) dir.x = 0;
    if (pos.y <= height/2 - roomH/2 + w/2 || pos.y >= height/2 + roomH/2 - w/2) dir.y = 0;
  }
}
