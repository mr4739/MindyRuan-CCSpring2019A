class Particle {
  public PVector pos = new PVector(0, 0);
  public PVector vel = new PVector(random(-1, 1), random(-1, 1));
  public PVector acc = new PVector(random(-0.05, 0.05), random(-0.05, 0.05));
  public float lifespan = 255;
  public float radius = random(10, 20);
  public color c = color(255);
  
  public Particle() {}
  
  // Particle constructor
  // PVector p: x, y position of particle
  // color col: color of particle
  public Particle(PVector p, color col) {
    pos.x = p.x;
    pos.y = p.y;
    c = col;
  }
  
  // Draw particle
  public void display() {
    fill(c, lifespan);
    circle(pos.x, pos.y, radius);
  }
  
  // Update particle position, velocity, and lifespan
  public void update() {
    pos.add(vel);
    vel.add(acc);
    lifespan -= 1;
  }
  
  // True is particle is dead, False otherwise
  public boolean isDead() {
    return lifespan < 0;
  }
}
