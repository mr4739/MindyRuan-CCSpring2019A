class Hitbox {
  float x = 0, y = 0;
  int w = 0, h = 0;
  
  public Hitbox(float x, float y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public void display() {
    fill (#FFF16C, 60);
    rect(x, y, w, h);
  }
  
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
