/*
Dungeon Crawler
*/

boolean isUp, isDown, isLeft, isRight;
Player player;
boolean isInvincible = false;
int invincStart;
int score;
int floorNum = 1;
int roomNum = 0;
Room[] floor = new Room[1];
Room currentRoom;
PImage roomImg;
PImage wallImg;

void setup() {
  size(1280, 1000);
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
  textSize(30);
  background(0);
  
  floor[0] = new Room(1, true, true);
  currentRoom = floor[0];
  player = new Player(new PVector(width/2, height/2 + currentRoom.w/4));
  roomImg = loadImage("map01.png");
  roomImg.resize(currentRoom.w, currentRoom.h);
  wallImg = loadImage("wall.png");
  wallImg.resize(currentRoom.w, wallImg.height);
}

void draw() {
  clear();
  checkDoors();
  // If player collides with a free friend, add to party and remove from room
  for (int i = 0; i < currentRoom.friends.size(); i++) {
    Friend f = currentRoom.friends.get(i);
    if (f.cageHP <= 0 && player.hitbox.isColliding(f.hitbox)) {
      player.partySize++;
      currentRoom.friends.remove(i);
    }
  }
  for (int i = 0; i < currentRoom.enemies.size(); i++) {
    if (isInvincible) break;
    Enemy e = currentRoom.enemies.get(i);
    if (player.hitbox.isColliding(e.hitbox)) {
      player.hp -= 5;
      isInvincible = true;
      invincStart = millis();
      player.speed = 7.0;
    }
  }
  for (int i = 0; i < currentRoom.bosses.size(); i++) {
    if (isInvincible) break;
    Boss b = currentRoom.bosses.get(i);
    if (player.hitbox.isColliding(b.hitbox)) {
      player.hp -= 5;
      isInvincible = true;
      invincStart = millis();
      player.speed = 7.0;
    }
  }
  if (isInvincible) {
    if (millis() > invincStart + 1.5 * 1000) {
      isInvincible = false;
      player.speed = 5.0;
    }
  }
  
  currentRoom.display();
  player.move(isUp, isDown, isLeft, isRight, currentRoom.w, currentRoom.h);
  player.display();
  displayInfo();
}

void checkDoors() {
  // If player colliding with entrance, go back to previous room
  if (player.hitbox.isColliding(currentRoom.entranceHB)) {
    // Go back if this isn't the first room on the floor
    if (roomNum != 0) {
      roomNum --;
      currentRoom = floor[roomNum];
      repositionPlayer(currentRoom.exitHB, currentRoom.exit);
      roomImg.resize(currentRoom.w, currentRoom.h);
      wallImg.resize(currentRoom.w, wallImg.height);
    } 
  }
  // If player colliding with exit,
  if (player.hitbox.isColliding(currentRoom.exitHB)) {
    // If this is the last room on the floor, go to next floor
    if (roomNum == floor.length-1) {
      nextFloor(currentRoom.exit);
      repositionPlayer(currentRoom.entranceHB, currentRoom.entrance);
      roomImg.resize(currentRoom.w, currentRoom.h);
      wallImg.resize(currentRoom.w, wallImg.height);
    } else {
      // Not last room, go to next room
      roomNum++;
      currentRoom = floor[roomNum];
      repositionPlayer(currentRoom.entranceHB, currentRoom.entrance);
      roomImg.resize(currentRoom.w, currentRoom.h);
      wallImg.resize(currentRoom.w, wallImg.height);
    }
  }
}

// Repositions player in the right spot when using doors
void repositionPlayer(Hitbox door, int direction) {
  switch(direction) {
    case 0: // DOWN
      player.pos.y = door.y - 11 - player.w/2;
      break;
    case 1: // UP
      player.pos.y = door.y + 11 + player.w/2;
      break;
    case 2: // RIGHT
      player.pos.x = door.x - 11 - player.w/2;
      break;
    case 3: // LEFT
      player.pos.x = door.x + 11 + player.w/2;
      break;
  }
}

// Goes to next floor
void nextFloor(int lastRoom) {
  roomNum = 0;
  floorNum++;
  // Generate new rooms for the new floor
  floor = new Room[floorNum];
  floor[0] = new Room(lastRoom, true, false);
  currentRoom = floor[0];
  for (int i = 1; i < floor.length; i++) {
    floor[i] = new Room(floor[i-1].exit, false, i+1 == floorNum);
  }
  // Regain 10 hp after finishing a floor, 100hp max
  player.hp = (player.hp <= 90) ? player.hp += 10 : 100;
}

void displayInfo() {
  fill(255);
  text("Floor: " + floorNum, width/10, height/2);
  text("Room: " + (roomNum+1), width/10, height/2+30);
  text("Friends: " + player.partySize, width/10, height/2 + 60);
  // Health bar
  if (player.hp > 50) {
    fill(#A0FF8E);
  } else {
    fill(#FA735B);
  }
  rect(width/2, 20, map(player.hp, 0, 100, 50, width-50), 20);
  text("" + player.hp + "/100", width/2, 60);
  text("Score: " + score, width/2, height - 40);
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    isUp = true;
    player.lastDir = 1; // UP
  }
  if (key == 's' || key == 'S') {
    isDown = true;
    player.lastDir = 0; // DOWN
  }
  if (key == 'a' || key == 'A') {
    isLeft = true;
    player.lastDir = 3; // LEFT
  }
  if (key == 'd' || key == 'D') {
    isRight = true;
    player.lastDir = 2; // RIGHT
  }
  if (key == 'o') player.hp -= 5;
  if (key == ' ') player.attack(currentRoom);
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    isUp = false;
  }
  if (key == 's' || key == 'S') {
    isDown = false;
  }
  if (key == 'a' || key == 'A') {
    isLeft = false;
  }
  if (key == 'd' || key == 'D') {
    isRight = false;
  }
}
