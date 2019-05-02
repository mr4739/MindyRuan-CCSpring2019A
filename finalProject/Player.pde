class Player {
  public PVector pos = new PVector(width/2, height/2);
  public int w = 40;
  public float speed = 5.0;
  public PVector dir = new PVector(0, 0);
  public int lastDir = 1;
  public int hp = 100;
  public Hitbox hitbox = new Hitbox(pos.x, pos. y, w, w);
  //ArrayList<Friend> party = new ArrayList<Friend>();
  public int partySize = 0;
  
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
    circle(pos.x, pos.y, w);
    hitbox.display();
  }
  
  public void attack(Room currentRoom) {
    // If party not empty, throw friend
    if (partySize > 0) {
      partySize--;
      int xDir = 0, yDir = 0;
      switch (lastDir) {
        case 0:
          yDir = 1;
          xDir = 0;
          break;
        case 1:
          yDir = -1;
          xDir = 0;
          break;
        case 2:
          xDir = 1;
          yDir = 0;
          break;
        case 3:
          xDir = -1;
          yDir = 0;
          break;
      }
      // Add thrown friend to room
      currentRoom.friends.add(new Friend(new PVector(pos.x + w*xDir*1.1, pos.y + w*yDir*1.1), new PVector(xDir, yDir), 0));
      currentRoom.friends.get(currentRoom.friends.size()-1).isFree = true;
    } else {
      // check player against caged friends
      for (int i = 0; i < currentRoom.friends.size(); i++) {
        if (currentRoom.friends.get(i).cageHP > 0 && hitbox.isColliding(currentRoom.friends.get(i).hitbox)) {
          // melee cage
          currentRoom.friends.get(i).cageHP -= 25;
        }
      }
      // check player against enemies
    }
  }
  
}
