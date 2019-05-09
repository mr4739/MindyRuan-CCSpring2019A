/*
Dungeon Crawler
*/
import processing.sound.*;

// constants to define game modes
final int START = 0, PLAY = 1, GAMEOVER = 2, INSTRUCTIONS = 3, CHEAT = 4, HIGHSCORE = 5;
// Sounds
SoundFile bgm, shoot, cageBreak, whoosh, doorLock, victory, gameOver;
// initial game mode
int mode = START;
// boolean flags for player movement
boolean isUp, isDown, isLeft, isRight;
Player player;
int playerMaxHp = 100;           // player's max HP
boolean isInvincible = false;    // Is the player currently invincible
int invincStart;                 // time invincibility activated
int score;                       // current score
int floorNum = 1;                // current floor number
int roomNum = 0;                 // current room number
Room[] floor = new Room[1];      // Current floor is array of Rooms
Room currentRoom;                // Current Room
PImage roomImg;                  // image of room floor
PImage wallImg;                  // image of upper wall
PImage lad1, lad2;               // default sized lad frames 1 & 2
PImage medLad1, medLad2;         // medium sized lad frames 1 & 2
PImage smallLad;                 // small sized lad, single frame
PImage enemy1, enemy2;           // enemy frames 1 & 2
PImage bossImg1, bossImg2;       // boss frames 1 & 2
PImage cage;                     // image of cage
boolean playerFrame = true;      // which frame to draw; true = 1, false = 2
PFont pixelmix;                  // pixel font
Table scores;                    // for highscores
char[] name = {char(65), char(65), char(65)};    // ['A', 'A', 'A']
int nameIndex = 0;               // index in name array to toggle

void setup() {
  size(1280, 1000);
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
  textSize(30);
  background(0);
  pixelmix = createFont("pixelmix.ttf", 25);  // load in font
  textFont(pixelmix);
  
  // load highscores csv, set score colume type to INT for sorting
  scores = loadTable("highscores.csv");
  scores.setColumnType(1, Table.INT);
  
  // Load all images, resize where applicable
  roomImg = loadImage("map01.png");
  //roomImg.resize(currentRoom.w, currentRoom.h);
  wallImg = loadImage("wall.png");
  //wallImg.resize(currentRoom.w, wallImg.height);
  lad1 = loadImage("lad1.png");
  lad2 = loadImage("lad2.png");
  medLad1 = loadImage("lad1.png");
  medLad2 = loadImage("lad2.png");
  medLad1.resize(40, 40);
  medLad2.resize(40, 40);
  smallLad = loadImage("lad1.png");
  smallLad.resize(20, 20);
  enemy1 = loadImage("enemy1.png");
  enemy2 = loadImage("enemy2.png");
  enemy1.resize(50, 50);
  enemy2.resize(50, 50);
  bossImg1 = loadImage("enemy1.png");
  bossImg2 = loadImage("enemy2.png");
  cage = loadImage("cage.png");
  cage.resize(20, 20);
  
  // Initialize first room of first floor
  // By default, exit is on upper wall
  // Current room is first room on first floor
  floor[0] = new Room(1, true, true);
  currentRoom = floor[0];
  // Initialize player
  player = new Player(new PVector(width/2, height/2 + currentRoom.w/4));
  
  // Load all sound files
  gameOver = new SoundFile(this, "GameOver.wav");
  bgm = new SoundFile(this, "GoblinTheme.wav");
  shoot = new SoundFile(this, "shoot.wav");
  cageBreak = new SoundFile(this, "break.wav");
  whoosh = new SoundFile(this, "whoosh.wav");
  doorLock = new SoundFile(this, "doorLock.wav");
  victory = new SoundFile(this, "victory.wav");
  // Play background music
  bgm.loop();
}

void draw() {
  clear();
  // Draw diff screens depending on current game mode
  switch(mode) {
  case START:
    startScreen();
    break;
  case PLAY:
    play();
    break;
  case GAMEOVER:
    gameOver();
    break;
  case INSTRUCTIONS:
    instructions();
    break;
  case CHEAT:
    cheat();
    break;
  case HIGHSCORE:
    highscore();
    break;
  }  
}

// When mode = PLAY
void play() {
  // If player is dead, set mode to GAMEOVER, play gameover music
  if (player.hp <= 0) {
    //TableRow newRow = scores.addRow();
    //newRow.setString(0, "asdf");
    //newRow.setInt(1, score);
    //scores.sortReverse(int(1));
    //for (TableRow row : scores.rows()) {
    //  println(row.getString(0) + ": " + row.getInt(1));
    //}
    //saveTable(scores, "highscores.csv");
    mode = GAMEOVER;
    bgm.stop();
    gameOver.loop();
  }
  // Checks if player is colliding with room's doors
  checkDoors();
  // If player collides with a free friend, add to party and remove from room
  for (int i = 0; i < currentRoom.friends.size(); i++) {
    Friend f = currentRoom.friends.get(i);
    // Only pick up if colliding and friend is not captured
    if (f.cageHP <= 0 && player.hitbox.isColliding(f.hitbox)) {
      player.partySize++;
      currentRoom.friends.remove(i);
    }
  }
  // Checks player against room's enemies
  for (int i = 0; i < currentRoom.enemies.size(); i++) {
    // Don't do anything if player is invincible
    if (isInvincible) break;
    Enemy e = currentRoom.enemies.get(i);
    if (player.hitbox.isColliding(e.hitbox)) {
      // If player collides with enemy, lose 5 hp
      // Player invincible and gets small speed boost
      player.hp -= 5;
      isInvincible = true;
      invincStart = millis();
      player.speed = 7.0;
    }
  }
  // Checks player against room's bosses
  for (int i = 0; i < currentRoom.bosses.size(); i++) {
    // Don't do anything if player is invincible
    if (isInvincible) break;
    Boss b = currentRoom.bosses.get(i);
    if (player.hitbox.isColliding(b.hitbox)) {
      // If player collides with enemy, lose 5 hp
      // Player invincible and gets small speed boost
      player.hp -= 5;
      isInvincible = true;
      invincStart = millis();
      player.speed = 7.0;
    }
  }
  // If player is currently invincible
  // Turn off invincibility and reset speed after 1 second
  if (isInvincible) {
    if (millis() > invincStart + 1 * 1000) {
      isInvincible = false;
      player.speed = 5.0;
    }
  }
  
  // Draw the current room
  currentRoom.display();
  // Update player position
  player.move(isUp, isDown, isLeft, isRight, currentRoom.w, currentRoom.h);
  // Draw player
  player.display();
  // Draw info
  displayInfo();
}

// Updates the current room if player collides with a door
void checkDoors() {
  // Only check for collisions if there are no bosses in the room
  if (currentRoom.bosses.size() == 0) {
    // If player colliding with entrance, go back to previous room
    if (player.hitbox.isColliding(currentRoom.entranceHB)) {
      // Go back if this isn't the first room on the floor
      if (roomNum != 0) {
        roomNum --;
        currentRoom = floor[roomNum];
        // reposition player to come out of the correct door
        repositionPlayer(currentRoom.exitHB, currentRoom.exit);
        // resize the room images to fit current room
        roomImg.resize(currentRoom.w, currentRoom.h);
        wallImg.resize(currentRoom.w, wallImg.height);
      } 
    }
    // If player colliding with exit,
    if (player.hitbox.isColliding(currentRoom.exitHB)) {
      // If this is the last room on the floor, go to next floor
      if (roomNum == floor.length-1) {
        nextFloor(currentRoom.exit);
        // reposition player to come out of the correct door
        repositionPlayer(currentRoom.entranceHB, currentRoom.entrance);
        // resize the room images to fit current room
        roomImg.resize(currentRoom.w, currentRoom.h);
        wallImg.resize(currentRoom.w, wallImg.height);
      } else {
        // Not last room, go to next room
        roomNum++;
        currentRoom = floor[roomNum];
        // reposition player to come out of the correct door
        repositionPlayer(currentRoom.entranceHB, currentRoom.entrance);
        // resize the room images to fit current room
        roomImg.resize(currentRoom.w, currentRoom.h);
        wallImg.resize(currentRoom.w, wallImg.height);
      }
    }
  }
}

// Repositions player in the right spot when using doors
// Hitbox door: hitbox of current room's entrance
// int direction: Which direction the player is coming from
void repositionPlayer(Hitbox door, int direction) {
  doorLock.play();  // play door sound
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
// int lastRoom: direction player came from
void nextFloor(int lastRoom) {
  victory.play();   // play victory sound
  roomNum = 0;      // Back to first room
  floorNum++;       // Increment floor number
  // Generate new rooms for the new floor
  // Number of rooms = floor number
  floor = new Room[floorNum];
  // Initialize first room with old direction
  floor[0] = new Room(lastRoom, true, false);
  currentRoom = floor[0];
  // Initialize the rest of the rooms
  for (int i = 1; i < floor.length; i++) {
    floor[i] = new Room(floor[i-1].exit, false, i+1 == floorNum);
  }
  // Regain 10 hp after finishing a floor, 100hp max
  player.hp = (player.hp <= playerMaxHp - 10) ? player.hp += 10 : playerMaxHp;
}

// When mode = GAMEOVER
void gameOver() {
  textSize(50);
  text("GAME OVER", width/2, 250);
  textSize(25);
  // Add new highscore if within top 5
  int numRows = (scores.getRowCount() > 5) ? 5 : 0;
  if (numRows == 0 || scores.getRow(numRows-1).getInt(1) < score) {
    text("Input name:", width/2, 350);
    textSize(50);
    // display name, green if selected, white if not
    for (int i = 0; i < name.length; i++) {
      if (i == nameIndex) {
        fill(0, 255, 0);
      } else {
        fill(255);
      }
      text(name[i], width/2 - 50 + i * 50, 440);
    }
    textSize(25);
    fill(255);
    text("SCORE: " + score, width/2, height/2);
    text("WASD - toggle name", width/2, height/2 + 140);
    text("SPACE - submit", width/2, height/2 + 180);
  // Shame the player if not
  } else {
    text("No high score!", width/2, 350);
    text("Try harder :)", width/2, 390);
    text("SCORE: " + score, width/2, height/2);
    text("SPACE - restart", width/2, height/2 + 100);
  }
}

// When mode = HIGHSCORE
void highscore() {
  textSize(50);
  text("HIGHSCORES", width/2, 300);
  int numRows = (scores.getRowCount() > 5) ? 5 : scores.getRowCount();
  textSize(25);
  // display the top 5 scores
  for (int i = 0; i < numRows; i++) {
    text(scores.getRow(i).getString(0) + "     " + scores.getRow(i).getInt(1), width/2, 350 + i * 50);
  }
  text("Q - go back", width/2, height/2 + 140);
}

// When mode = START
void startScreen() {
  // switch player frame every 10 frames
  if (frameCount % 10 == 0) playerFrame = !playerFrame;
  // true: draw frame 1; false: draw frame 2
  if (playerFrame) {
      image(lad1, width/2+70, height/2-50);
  } else {
      image(lad2, width/2+70, height/2-50);
  }
  // 3 smaller friends, same logic
  for (int i = 0; i < 3; i++) {
    if (playerFrame) {
      image(medLad1, width/2 - 10 - i*50, height/2-20);
    } else {
      image(medLad2, width/2 - 10 - i*50, height/2-20);
    }
  }
  text("SPACE - start game", width/2, height/2 + 40);
  text("I - instructions", width/2, height/2 + 80);
  text("H - highscores", width/2, height/2 + 120);
  text("C - cheat", width/2, height/2 + 160);
}

// When mode = INSTRUCTIONS
void instructions() {
  textSize(50);
  text("INSTRUCTIONS", width/2, height/2 - 60);
  textSize(25);
  text("WASD - move", width/2, height/2);
  text("SPACE - attack", width/2, height/2 + 40);
  text("Q - go back", width/2, height/2 + 120);
}

// When mode = CHEAT
void cheat() {
  textSize(50);
  text("CHEAT", width/2, height/2 - 60);
  textSize(25);
  text("<R     Friends: " + player.partySize + "    T>", width/2, height/2);
  text("<F       HP: " + playerMaxHp + "      G>", width/2, height/2 + 40);
  text("Q - go back", width/2, height/2 + 120);
}

// Display game info
void displayInfo() {
  // Health bar - green: more than half; red: less
  if (player.hp > playerMaxHp/2) {
    fill(#A0FF8E);
  } else if (player.hp > playerMaxHp/4) {
    fill(#FFD548);
  } else {
    fill(#FA735B);
  }
  rect(width/2, 20, map(player.hp, 0, playerMaxHp, 50, width-50), 20);
  text("" + player.hp + "/" + playerMaxHp, width/2, 60);
  // Display score
  fill(255);
  text("" + floorNum + "F " + (roomNum+1) + "R", 200, height - 40);
  text("Score: " + score, width/2, height - 40);
  text("Friends: " + player.partySize, width - 200, height - 40);
}

// Resets game, goes back to start screen
void reset() {
  score = 0;
  isInvincible = false;
  floorNum = 1;
  roomNum = 0;
  floor = new Room[1];
  floor[0] = new Room(1, true, true);
  currentRoom = floor[0];
  player = new Player(new PVector(width/2, height/2 + currentRoom.w/4));
  roomImg.resize(currentRoom.w, currentRoom.h);
  wallImg.resize(currentRoom.w, wallImg.height);
  mode = START;
}

void keyPressed() {
  // If currently playing
  if (mode == PLAY) {
    // WASD - set movement flags and player's last direction pressed
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
    // SPACE to attack
    if (key == ' ') player.attack(currentRoom);
  // Game over screen controls
  } else if (mode == GAMEOVER) {
    // WASD - toggle name
    if (key == 'a' || key == 'A') {
      nameIndex = (nameIndex > 0) ? nameIndex - 1 : 2;
    }
    if (key == 'd' || key == 'D') {
      nameIndex = (nameIndex < 2) ? nameIndex + 1 : 0;
    }
    if (key == 'w' || key == 'w') {
      name[nameIndex] = (int(name[nameIndex]) > 65) ? char(int(name[nameIndex]) - 1) : char(90);
    }
    if (key == 's' || key == 'S') {
      name[nameIndex] = (int(name[nameIndex]) < 90) ? char(int(name[nameIndex]) + 1) : char(65);
    }
    // SPACE - submit score or restart
    if (key == ' ') {
      int numRows = (scores.getRowCount() > 5) ? 5 : 0;
      // Submit score if within top 5
      if (numRows == 0 || scores.getRow(numRows-1).getInt(1) < score) {
        // New row with name and score
        TableRow newRow = scores.addRow();
        newRow.setString(0, new String(name));
        newRow.setInt(1, score);
        // sort the table in reverse
        scores.sortReverse(int(1));
        saveTable(scores, "highscores.csv");
        // Go to highscore screen
        mode = HIGHSCORE;
      // Otherwise, restart
      } else {
        reset();
      }
      gameOver.stop();
      bgm.loop();
    }
  } else if (mode == HIGHSCORE) {
    // Q - go back to start
    if (key == 'q' || key == 'Q') {
      reset();
    }
  // Start screen controls
  } else if (mode == START) {
    // SPACE - start game
    if (key == ' ') { 
      mode = PLAY;
    }
    // Switch to instructions/cheat screens
    if (key == 'i' || key == 'I') mode = INSTRUCTIONS;
    if (key == 'h' || key == 'H') mode = HIGHSCORE;
    if (key == 'c' || key == 'C') mode = CHEAT;
  // Instructions screen controls
  } else if (mode == INSTRUCTIONS) {
    // Q - go back to start
    if (key == 'q' || key == 'Q') mode = START;
  // Cheat screen controls
  } else if (mode == CHEAT) {
    // R/T change friends
    if (key == 'r' || key == 'R') {
      player.partySize = (player.partySize - 1 < 0) ? 0 : player.partySize - 1;
    }
    if (key == 't' || key == 'T') {
      player.partySize = (player.partySize + 1 > 100) ? 100 : player.partySize + 1;
    }
    // F/G change HP
    if (key == 'f' || key == 'F') {
      playerMaxHp = (playerMaxHp - 10 < 10) ? 10 : playerMaxHp - 10;
    }
    if (key == 'g' || key == 'G') {
      playerMaxHp = (playerMaxHp + 10 > 500) ? 500 : playerMaxHp + 10;
    }
    // Q - go back to start
    if (key == 'q' || key == 'Q') { 
      mode = START;
      player.hp = playerMaxHp;
    }
  }
}

// Toggle movement flags on release
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
