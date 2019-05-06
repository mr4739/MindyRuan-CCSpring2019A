class Friend {
  public PVector pos = new PVector(width/2, height/2);
  public boolean isFree = false;
  public float speed = 8.0;
  public PVector dir = new PVector(0,0);
  public int w = 20;
  public Hitbox hitbox;
  public int cageHP = 0;
  
  public Friend(PVector position, PVector direction, int cageHP) {
    pos.x = position.x;
    pos.y = position.y;
    dir.x = direction.x;
    dir.y = direction.y;
    hitbox = new Hitbox(position.x, position.y, w, w);
    this.cageHP = cageHP;
  }
  
  public void display(float roomW, float roomH) {
    if (dir.x != 0 || dir.y != 0) update(roomW, roomH);
    image(smallLad1, pos.x, pos.y);
    if (!isFree) image(cage, pos.x, pos.y);
    hitbox.display();
  }
  
  public void update(float roomW, float roomH) {
    pos.x += speed * dir.x;
    pos.y += speed * dir.y;
    pos.x = constrain(pos.x, width/2 - roomW/2 + w/2, width/2 + roomW/2 - w/2);
    pos.y = constrain(pos.y, height/2 - roomH/2 + w/2, height/2 + roomH/2 - w/2);
    hitbox.x = pos.x;
    hitbox.y = pos.y;
    if (pos.x <= width/2 - roomW/2 + w/2 || pos.x >= width/2 + roomW/2 - w/2) dir.x = 0;
    if (pos.y <= height/2 - roomH/2 + w/2 || pos.y >= height/2 + roomH/2 - w/2) dir.y = 0;
  }
}
