// Constants for door generation
private int DOWN = 0, UP = 1, RIGHT = 2, LEFT = 3;

class Room {
  public int w = int(random(600, 1000)), h = int(random(500, 700));
  public int entrance = UP;                // entrance direction
  public int exit = floor(random(0,4));    // exit direction
  public Hitbox entranceHB, exitHB;        // entrance and exit hitboxes
  public ArrayList<Friend> friends = new ArrayList<Friend>();  // Friends in this room
  public ArrayList<Enemy> enemies = new ArrayList<Enemy>();    // Enemies in this room
  public ArrayList<Boss> bosses = new ArrayList<Boss>();       // Bosses in this room
  public boolean firstRoom = false, lastRoom = false;          // is this the first/last room?
  public PImage floor;
  public PImage wall;
  
  // Room constructor
  // int oppositeEnt: direction opposite the entrance
  // boolean firstRoom: is this the first room on floor
  // boolean lastRoom: is this the last room on floor
  public Room(int oppositeEnt, boolean firstRoom, boolean lastRoom) {
    this.firstRoom = firstRoom;
    this.lastRoom = lastRoom;
    // Put entrance on opposite direction
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
    // While exit direction = entrance direction, reposition exit randomly
    while(exit == entrance) exit = floor(random(0,4));
    if (exit == UP || exit == DOWN) {
      exitHB = new Hitbox(width/2, height/2-h/2 + (1 - exit) * h, 100, 20);
    } else {
      exitHB = new Hitbox(width/2-w/2 + (3 - exit) * w, height/2, 20, 100);
    }
    // If this is last room on floor, spawn a caged friend
    if (lastRoom) {
      friends.add(new Friend(new PVector(width/2, height/2), new PVector(0, 0), 50));
    }
    // Random number of basic enemies in room
    int numEnemies = int(random(2, 4));
    // Spawn basic enemies if not last room
    if ((!firstRoom && !lastRoom) || (firstRoom && !lastRoom)) {
      for (int i = 0; i < numEnemies; i++) {
        enemies.add(new Enemy(w, h, entranceHB.x, entranceHB.y));
      }
      // Spawn projectile enemies if floor is higher than 5
      if (floorNum >= 2) {
        // Random number of projectile enemies
        int numProjEnemies = int(random(1, 4));
        for (int i = 0; i < numProjEnemies; i++) {
          enemies.add(new ProjectileEnemy(w, h, entranceHB.x, entranceHB.y));
        }
      }
    // If last room, spawn boss
    } else if (!firstRoom && lastRoom) {
      // gets bigger every 5 floors
      int bossSize = 3 + floorNum/5;
      // max divisions = 10
      if (bossSize > 10) bossSize = 10;
      bosses.add(new Boss(bossSize));
    }
    floor = roomImg.get();
    wall = wallImg.get();
    floor.resize(w, h);
    wall.resize(w, wall.height);
  }
  
  // Draw Room and its entities
  public void display() {
    // draw room
    fill(#8f673f);
    rect(width/2, height/2, w, h);
    image(wall, width/2, height/2 - h/2 - wallImg.height/2);
    image(floor, width/2, height/2);
    
    // Draw doors if not a boss room
    if (bosses.size() == 0) {
      // draw entrance
      if (!firstRoom) {
        fill(255); // white
        rect(entranceHB.x, entranceHB.y, entranceHB.w, entranceHB.h);
      }
      // draw exit
      fill(0); // black
      rect(exitHB.x, exitHB.y, exitHB.w, exitHB.h);
    }
    
    // draw all friends in the room
    for (int i = 0; i < friends.size(); i++) {
      friends.get(i).display(w, h);
    }
    
    // Remove dead enemies, +100 for each enemy killed
    // Update and draw enemies
    for (int i = 0; i < enemies.size(); i++) {
      if (enemies.get(i).hp <= 0) {
        enemies.remove(i);
        score += 100;
        break;
      }
      enemies.get(i).update();
      enemies.get(i).display();
    }
    // Remove dead bosses, +1000 for each boss fully killed
    // Update and draw bosses
    for (int i = 0; i < bosses.size(); i++) {
      if (bosses.get(i).hp <= 0) {
        bosses.remove(i);
        if (bosses.size() == 0) score += 1000;
        break;
      }
      bosses.get(i).update();
      bosses.get(i).display();
    }
    // check for collisions between thrown friends & everything
    checkFriendsCollision();
  }
  
  // Checks for collision between thrown friends & everything
  public void checkFriendsCollision() {
    // For each friend in this room
    for (int i = 0; i < friends.size(); i++) {
      // friends(i) is moving (thrown weapon)
      // If friend isn't moving, continue
      if (friends.get(i).dir.x == 0 && friends.get(i).dir.y == 0) continue;
      // friends(j) is caged friend
      for (int j = 0; j < friends.size(); j++) {
        // If friend(j) is caged and hitboxes collide, free friend
        if (friends.get(j).cageHP > 0 && friends.get(i).hitbox.isColliding(friends.get(j).hitbox)) {
          friends.get(j).cageHP -= 50;
          cageBreak.play();
          friends.get(j).isFree = true;
          // Stop thrown friend
          friends.get(i).dir.x = 0;
          friends.get(i).dir.y = 0;
          break;
        }
      }
      // Check against enemies
      for (int j = 0; j < enemies.size(); j++) {
        // Thrown friend collides with enemy, do 50 dmg, stop friend
        if (friends.get(i).hitbox.isColliding(enemies.get(j).hitbox)) {
          friends.get(i).dir.x = 0;
          friends.get(i).dir.y = 0;
          enemies.get(j).loseHP(50);
          break;
        }
      }
      // Check against bosses
      for (int j = 0; j < bosses.size(); j++) {
        // Thrown friend collides with boss, do 50 dmg, split boss
        if (friends.get(i).hitbox.isColliding(bosses.get(j).hitbox)) {
          friends.get(i).dir.x = 0;
          friends.get(i).dir.y = 0;
          bosses.get(j).loseHP(50);
          bosses.add(new Boss(bosses.get(j)));
          break;
        }
      }
    }
  }
  
}
