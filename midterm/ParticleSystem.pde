class ParticleSystem {
  public ArrayList<Particle> particles = new ArrayList<Particle>();
  public PVector pos = new PVector(0, 0);
  public int start = 0;  // time PS was created
  public color c;
  
  public ParticleSystem() {}
  
  // ParticleSystem constructor
  // PVector p: center x, y position of particle system
  // color col: color of particles
  public ParticleSystem(PVector p, color col) {
    // store current time in milliseconds
    start = millis();
    pos.x = p.x;
    pos.y = p.y;
    c = col;
  }
  
  // True if Particle System is dead; False otherwise
  public boolean isDead() {
    // Dead if current time is more than 1 second after start
    return millis() > start + 0.5*1000;
  }
  
  // Run particle system
  public void run() {
    // Draw each particle in system
    // If particle is dead, remove it from system
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).display();
      particles.get(i).update();
      if (particles.get(i).isDead()) particles.remove(i);
    }
    // If particle system is not dead, continue adding particles
    if (!isDead()) addParticle(c);
  }
  
  // Adds particle to system
  // color c: color of particle
  public void addParticle(color c) {
    particles.add(new Particle(pos, c));
  }
}
