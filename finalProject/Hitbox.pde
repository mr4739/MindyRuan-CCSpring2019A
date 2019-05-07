class Hitbox {
  float x = 0, y = 0;    // position of hitbox
  float w = 0, h = 0;    // hitbox width, height
  
  // Hitbox constructor
  // float x, y: position
  // float w, h: size
  public Hitbox(float x, float y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  // Draw hitbox, for debugging
  //public void display() {
  //  fill (#FFF16C, 60);
  //  rect(x, y, w, h);
  //}
  
  // Returns true if hitbox collides with other hitbox, false otherwise
  // Hitbox other: other hitbox to check against
  public boolean isColliding(Hitbox other) {
    /*
    B bottom >= A top && 
    B top <= A bottom &&
    B right >= A left &&
    B left <= A right
    */
    if (this.y + this.h/2 >= other.y - other.h/2
      && this.y - this.h/2 <= other.y + other.h/2
      && this.x + this.w/2 >= other.x - other.w/2
      && this.x - this.w/2 <= other.x + other.w/2) {
        return true;
    }
    return false;
  }
}
