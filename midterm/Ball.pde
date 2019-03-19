class Ball {
  public PVector pos;
  // default 0 velX, -6 velY
  public PVector vel = new PVector(0, -6);
  public ArrayList<ParticleSystem> ps = new ArrayList<ParticleSystem>();
  
  public Ball() {}
  // PVector p = initial position PVector
  public Ball(PVector p) {
    pos = new PVector(p.x, p.y);
  }
  
  // Draw ball
  public void display() {
    fill(360, 0, 100); // white
    circle(pos.x, pos.y, 30);
  }
  
  // Update ball position
  // ArrayList<Brick> bricks: remaining bricks arraylist
  public boolean update(ArrayList<Brick> bricks) {
    // Add velocity to position
    pos.add(vel);
    // Limit ball within screen
    pos.x = constrain(pos.x, 15, width-15);
    // run existing particle systems
    for (int i = 0; i < ps.size(); i++) {
      ps.get(i).run();
      // if particle system has no particles left, remove it
      if (ps.get(i).particles.size() == 0) ps.remove(i);
    }
    // check if ball collides with any bricks
    return checkCollisions(bricks);
  }
  
  // Collision checking of ball with bricks
  // True: collision occured
  // False: no collision
  public boolean checkCollisions(ArrayList<Brick> bricks) {
    for (int i = 0; i < bricks.size(); i++) {
      Brick b = bricks.get(i);
      // If ball collides with top/bottom of brick, reverse y direction
      if (pos.y-15 + vel.y/2 <= b.pos.y+b.size.y/2.0 
          && pos.y+15 + vel.y/2>= b.pos.y-b.size.y/2.0
          && pos.x+15 >= b.pos.x-b.size.x/2.0
          && pos.x-15 <= b.pos.x+b.size.x/2.0) {
        // add a particle system where brick was destroyed
        ps.add(new ParticleSystem(new PVector(b.pos.x, b.pos.y), b.c));
        // remove this brick from arraylist
        bricks.remove(i);
        // reverse y direction
        vel.y *= -1;
        // increase Y velocity a little
        vel.y += 0.1;
        return true;
      }
      // If ball collides with left/right of brick, reverse x direction
      if (pos.y-15 <= b.pos.y+b.size.y/2.0 
          && pos.y+15 >= b.pos.y-b.size.y/2.0
          && pos.x+15 + vel.x/2 >= b.pos.x-b.size.x/2.0
          && pos.x-15 + vel.x/2 <= b.pos.x+b.size.x/2.0) {
        // add a particle system where brick was destroyed
        ps.add(new ParticleSystem(new PVector(b.pos.x, b.pos.y), b.c));
        // remove this brick from arraylist
        bricks.remove(i);
        // reverse x direction
        vel.x *= -1;
        return true;
      }
    }
    // If ball collides with left/right walls of screen, reverse x direction
    if (pos.x-15 <= 0 || pos.x+15 >= width) vel.x *= -1;
    // If ball collides with top of screen, reverse y direction
    if (pos.y-15 <= 0) vel.y *= -1;
    return false;
  }
}
