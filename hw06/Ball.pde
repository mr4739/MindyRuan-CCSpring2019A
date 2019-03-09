class Ball {
  public PVector pos = new PVector(width/2, height/2);
  public PVector vel = new PVector(random(-5.0, 5.0), random(-5.0, 5.0));
  public color c = color(random(255), random(255), random(255));
  public ArrayList<ParticleSystem> ps = new ArrayList<ParticleSystem>();
  
  public Ball() {}
  
  // Ball Constructor
  // PVector v: velocity x, y
  public Ball(PVector v) {
    vel.x = v.x;
    vel.y = v.y;
  }
  
  // Checks collisions and updates ball position
  public void update(float p1, float p2) {
    // update position
    pos.add(vel);
    
    // Top/bottom edge collision; add particle effect
    if (pos.y <= 10 || pos.y >= height-10) {
      vel.y *= -1;
      ps.add(new ParticleSystem(new PVector(pos.x, pos.y), c));
    }
    
    // Paddle 1 collision; add particle effect
    if (pos.y-10 < p1+40 && pos.y+10 > p1-40 && 
        pos.x+10 + vel.x> width/10-10 && pos.x-10 + vel.x < width/10+10) {
      vel.x *= -1;
      ps.add(new ParticleSystem(new PVector(pos.x, pos.y), c));
    }
    if (pos.y-10 + vel.y < p1+40 && pos.y+10 + vel.y > p1-40 && 
        pos.x+10 > width/10-10 && pos.x-10 < width/10+10) {
      if (pos.y < p1) pos.y = p1-50;
      if (pos.y > p1) pos.y = p1+50;
      vel.y *= -1;
    }
    
    // Paddle 2 collision; add particle effect
    if (pos.y-10 < p2+40 && pos.y+10 > p2-40 && 
        pos.x+10 + vel.x> 9*width/10-10 && pos.x-10 + vel.x < 9*width/10+10) {
      vel.x *= -1;
      ps.add(new ParticleSystem(new PVector(pos.x, pos.y), c));
    }
    if (pos.y-10 + vel.y < p2+40 && pos.y+10 + vel.y > p2-40 && 
        pos.x+10 > 9*width/10-10 && pos.x-10 < 9*width/10+10) {
      if (pos.y < p1) pos.y = p2-50;
      if (pos.y > p1) pos.y = p2+50;
      vel.y *= -1;
    }
    // Run particle systems
    runPS();
  }
  
  // Runs each particle system, removes dead ones
  public void runPS() {
    for (int i = 0; i < ps.size(); i++) {
      ps.get(i).run();
      if (ps.get(i).isDead()) ps.remove(i);
    }
  }
  
  // Draw ball
  public void display() {
    fill(c);
    circle(pos.x, pos.y, 20);
  }
  
  // Reset ball in middle
  // int direction: [-1: towards Player 1] [1: towards Player 2]
  public void reset(int direction) {
    pos.x = width/2;
    pos.y = height/2;
    vel.x = random(direction * 2.0, direction * 5.0);
    vel.y = random(-5.0, 5.0);
  }
}
