class Player {
  public PVector pos = new PVector(width/2, height/2);    // position
  public int w = 40;                                      // width
  public float speed = 5.0;                               // movement speed
  public int lastDir = 1;                                 // last movement direction
  public int hp = 100;                                    // player's hp
  public Hitbox hitbox = new Hitbox(pos.x, pos. y, w, w); // player's hitbox
  public int partySize = 0;                               // number of friends in party
  
  // Player constructor
  // PVector position: initial position
  public Player(PVector position) {
    pos.x = position.x;
    pos.y = position.y;
  }
  
  // Updates player position
  // booleans: movement boolean flags
  // int roomW, int roomH: room size
  public void move(boolean isUp, boolean isDown, boolean isLeft, boolean isRight, int roomW, int roomH) {
    pos.x += speed * (int(isRight) - int(isLeft));
    pos.y += speed * (int(isDown) - int(isUp));
    pos.x = constrain(pos.x, width/2 - roomW/2 + w/2, width/2 + roomW/2 - w/2);
    pos.y = constrain(pos.y, height/2 - roomH/2 + w/2, height/2 + roomH/2 - w/2);
    hitbox.x = pos.x;
    hitbox.y = pos.y;
  }
  
  // Draw player
  public void display() {
    // Switch player frame every 10 frames
    if (frameCount % 10 == 0) playerFrame = !playerFrame;
    // Draw frame 1 if true, frame 2 if false
    if (playerFrame) {
      image(medLad1, pos.x, pos.y);
    } else {
      // Don't draw frame 2 if invincible
      if (!isInvincible) image(medLad2, pos.x, pos.y);
    }
    //hitbox.display();
  }
  
  // Attack method
  // Room currentRoom: current room
  public void attack(Room currentRoom) {
    whoosh.play(); // play whoosh sound
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
          // melee cage, 25 dmg
          currentRoom.friends.get(i).cageHP -= 25;
          if (currentRoom.friends.get(i).cageHP == 0) cageBreak.play();
        }
      }
      // check player against enemies
      for (int i = 0; i < currentRoom.enemies.size(); i++) {
        if (hitbox.isColliding(currentRoom.enemies.get(i).hitbox)) {
          // melee enemy, 25 dmg
          currentRoom.enemies.get(i).hp -= 25;
        }
      }
    }
  }
  
}
