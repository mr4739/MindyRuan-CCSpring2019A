/*
Boss appears on last room of each floor
- start out larger and slower
- divide when hit, becomes smaller and faster
*/

class Boss extends Enemy {
  public int divisions = 0; // Number of divisions
  public float size = 30;   // Default size
  public PImage img1, img2;
  
  // Boss constructor
  // int divs: number of divisions
  public Boss(int divs) {
    // use Enemy constructor
    super(width/2, height/2, divs * 30);
    divisions = divs;
    size = divs * 30;
    hp = 50 * divisions;
    speed = 1.5 / divisions;
    img1 = bossImg1.get();
    img2 = bossImg2.get();
    if (size > 0) {
      img1.resize(int(size), int(size));
      img2.resize(int(size), int(size));
    }
  }
  
  // Boss constructor
  // Boss other: the original Boss to split from
  public Boss(Boss other) {
    // Use the original's info to initialize
    super(other.pos.x, other.pos.y, other.size);
    divisions = other.divisions;
    size = divisions * 30;
    // Reposition the bosses
    other.pos.x -= size/2;
    pos.x += size/2;
    hp = 50 * divisions;
    speed = 1.5 / divisions;
    img1 = other.img1.get();
    img2 = other.img2.get();
  }
  
  // Draw boss
  public void display() {
    // Sync with player frame
    // Draw frame 1 if true, frame 2 if false
    if (playerFrame) {
      image(img1, pos.x, pos.y);
    } else {
      image(img2, pos.x, pos.y);
    }
  }
  
  // When hit, lose hp
  // Decrease size, increase speed
  public void loseHP(int amt) {
    hp -= amt;
    divisions--;
    size = divisions * 30;
    hitbox.w = size;
    hitbox.h = size;
    speed = 1.5 / divisions;
    if (size > 0) {
      img1.resize(int(size), int(size));
      img2.resize(int(size), int(size));
    }
  }
}
