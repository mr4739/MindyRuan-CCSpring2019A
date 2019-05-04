private int DOWN = 0, UP = 1, RIGHT = 2, LEFT = 3;

class Room {
  public int w = int(random(600, 1000)), h = int(random(500, 750));
  public int entrance = 1;
  public int exit = floor(random(0,4));
  public Hitbox entranceHB, exitHB;
  public ArrayList<Friend> friends = new ArrayList<Friend>();
  public ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  public boolean firstRoom = false, lastRoom = false;
  //public PImage roomImgRescale = roomImg.resize(w, h);
  
  public Room(int oppositeEnt, boolean firstRoom, boolean lastRoom) {
    this.firstRoom = firstRoom;
    this.lastRoom = lastRoom;
    if (oppositeEnt == UP) { 
      entrance = DOWN;
      entranceHB = new Hitbox(width/2, height/2 + h/2, 100, 20);
    } else if (oppositeEnt == DOWN) {
      entrance = UP;
      entranceHB = new Hitbox(width/2, height/2 - h/2, 100, 20);
    } else if (oppositeEnt == LEFT) {
      entrance = RIGHT;
      entranceHB = new Hitbox(width/2 + w/2, height/2, 20, 100);
    } else if (oppositeEnt == RIGHT) {
      entrance = LEFT;
      entranceHB = new Hitbox(width/2 - w/2, height/2, 20, 100);
    }
    while(exit == entrance) exit = floor(random(0,4));
    if (exit == UP || exit == DOWN) {
      exitHB = new Hitbox(width/2, height/2-h/2 + (1 - exit) * h, 100, 20);
    } else {
      exitHB = new Hitbox(width/2-w/2 + (3 - exit) * w, height/2, 20, 100);
    }
    if (lastRoom) {
      friends.add(new Friend(new PVector(width/2, height/2), new PVector(0, 0), 50));
    }
    int numEnemies = int(random(2, 5));
    if ((!firstRoom && !lastRoom) || (firstRoom && !lastRoom)) {
      for (int i = 0; i < numEnemies; i++) {
        enemies.add(new Enemy(w, h, entranceHB.x, entranceHB.y));
      }
    } else if (!firstRoom && lastRoom) {
      enemies.add(new Boss(3));
    }
  }
  
  public void display() {
    // draw room
    fill(#8f673f);
    rect(width/2, height/2, w, h);
    
    image(wallImg, width/2, height/2 - h/2 - wallImg.height/2);
    image(roomImg, width/2, height/2);
    
    // draw entrance
    if (!firstRoom) {
      fill(#A0FF8E); // green
      rect(entranceHB.x, entranceHB.y, entranceHB.w, entranceHB.h);
    }
    // draw exit
    fill(#FA735B); // red
    rect(exitHB.x, exitHB.y, exitHB.w, exitHB.h);
    
    // draw all friends in the room
    for (int i = 0; i < friends.size(); i++) {
      friends.get(i).display(w, h);
    }
    
    for (int i = 0; i < enemies.size(); i++) {
      if (enemies.get(i).hp <= 0) {
        enemies.remove(i);
        break;
      }
      enemies.get(i).chase();
      enemies.get(i).display();
    }
    // check for collisions between friends
    checkFriendsCollision();
  }
  
  public void checkFriendsCollision() {
    for (int i = 0; i < friends.size(); i++) {
      // friends(i) is moving (thrown weapon)
      if (friends.get(i).dir.x == 0 && friends.get(i).dir.y == 0) continue;
      // friends(j) is caged friend
      for (int j = 0; j < friends.size(); j++) {
        if (friends.get(j).cageHP > 0 && friends.get(i).hitbox.isColliding(friends.get(j).hitbox)) {
          friends.get(j).cageHP -= 50;
          friends.get(j).isFree = true;
          friends.get(i).dir.x = 0;
          friends.get(i).dir.y = 0;
          break;
        }
      }
      for (int j = 0; j < enemies.size(); j++) {
        if (friends.get(i).hitbox.isColliding(enemies.get(j).hitbox)) {
          println("Hit");
          friends.get(i).dir.x = 0;
          friends.get(i).dir.y = 0;
          enemies.get(j).hp -= 50;
          break;
        }
      }
    }
  }
  
}
