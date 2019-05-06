class Player {
  public PVector pos = new PVector(width/2, height/2);
  public int w = 40;
  public float speed = 5.0;
  public PVector dir = new PVector(0, 0);
  public int lastDir = 1;
  public int hp = 100;
  public Hitbox hitbox = new Hitbox(pos.x, pos. y, w, w);
  public int partySize = 10;
  
  public Player(PVector position) {
    pos.x = position.x;
    pos.y = position.y;
  }
  
  public void move(boolean isUp, boolean isDown, boolean isLeft, boolean isRight, int roomW, int roomH) {
    pos.x += speed * (int(isRight) - int(isLeft));
    pos.y += speed * (int(isDown) - int(isUp));
    pos.x = constrain(pos.x, width/2 - roomW/2 + w/2, width/2 + roomW/2 - w/2);
    pos.y = constrain(pos.y, height/2 - roomH/2 + w/2, height/2 + roomH/2 - w/2);
    hitbox.x = pos.x;
    hitbox.y = pos.y;
  }
  
  public void display() {
    fill(255);
    if (isInvincible) fill(0, 255, 0);
    //circle(pos.x, pos.y, w);
    if (frameCount % 10 == 0) playerFrame = !playerFrame;
    if (playerFrame) {
      image(lad1, pos.x, pos.y);
    } else {
      image(lad2, pos.x, pos.y);
    }
    hitbox.display();
  }
  
  public void attack(Room currentRoom) {
    // If party not empty, throw friend
    if (partySize > 0) {
      partySize--;
      // Add thrown friend to room
      if (lastDir == 0) currentRoom.friends.add(new Friend(new PVector(pos.x, pos.y + w*1.1), new PVector(0, 1), 0));
      if (lastDir == 1) currentRoom.friends.add(new Friend(new PVector(pos.x, pos.y + w*-1.1), new PVector(0, -1), 0));
      if (lastDir == 2) currentRoom.friends.add(new Friend(new PVector(pos.x + w*1.1, pos.y), new PVector(1, 0), 0));
      if (lastDir == 3) currentRoom.friends.add(new Friend(new PVector(pos.x + w*-1.1, pos.y), new PVector(-1, 0), 0));
      currentRoom.friends.get(currentRoom.friends.size()-1).isFree = true;
    } else {
      // Party empty, melee
      // check player against caged friends
      for (int i = 0; i < currentRoom.friends.size(); i++) {
        if (currentRoom.friends.get(i).cageHP > 0 && hitbox.isColliding(currentRoom.friends.get(i).hitbox)) {
          // melee cage
          currentRoom.friends.get(i).cageHP -= 25;
        }
      }
      // check player against enemies
      for (int i = 0; i < currentRoom.enemies.size(); i++) {
        if (hitbox.isColliding(currentRoom.enemies.get(i).hitbox)) {
          // melee enemy
          currentRoom.enemies.get(i).hp -= 25;
        }
      }
    }
  }
  
}
