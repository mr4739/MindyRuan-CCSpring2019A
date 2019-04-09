/*
hw10/sketch.js
Author: Mindy Ruan
Summary: Pong, p5 edition

CONTROLS:
*** W/S - move player 1 paddle up/down
*** I/K - move player 2 paddle up/down
*** P - toggle pause, start game
*** R - reset game
*** T - spawn new ball
*/

var balls = [];
var p1Y, p2Y;                   // Paddle 1 & 2 positions
var p1Vel = 6, p2Vel = 6;       // Paddle velocities
var p1Score = 0, p2Score = 0;
var paused = true;
// Flags to indicate if up/down controls are held down
// up1, down1 for paddle 1, others for paddle 2
var up1 = false, down1 = false, up2 = false, down2 = false;

function setup() {
    createCanvas(windowWidth, windowHeight-40);
    noStroke();
    rectMode(CENTER);
    textAlign(CENTER);
    textSize(30);
    // Starting ball in middle, paddles in middle
    balls.push(new Ball(new Vector2D(-5, 5)));
    p1Y = height/2;
    p2Y = height/2;
}

function draw() {
    background(0);
    // Drawing balls
    for (let i = 0; i < balls.length; i++) {
        // If game isn't paused, update positions
        if (!paused) balls[i].update(p1Y, p2Y);
        
        // If ball reaches left edge, P2 gets point, reset ball
        if (balls[i].pos.x <= 10) {
            balls[i].reset(1);
            p2Score++;
        // If ball reaches right edge, P1 gets point, reset ball
        } else if (balls[i].pos.x >= width-10) {
            balls[i].reset(-1);
            p1Score++;
        }
        balls[i].display();
    }

    // Update paddle positions based on up/down flags
    p1Y += p1Vel * (int(down1)-int(up1));
    p2Y += p2Vel * (int(down2)-int(up2));
    // Constrain paddle to within bounds of canvas
    p1Y = constrain(p1Y, 40, height-40);
    p2Y = constrain(p2Y, 40, height-40);

    // Draw both paddles
    fill(255);
    rect(width/10, p1Y, 20, 80);        // Paddle 1
    rect(9 * width/10, p2Y, 20, 80);    // Paddle 2

    // Score printing
    text("P1 Score: " + p1Score, width/5, 50);
    text("P2 Score: " + p2Score, 4 * width/5, 50);
}

function keyPressed() {
    // R to reset game and scores
    if (key == 'r' || key == 'R') {
        p1Score = 0;
        p2Score = 0;
        p1Y = height/2;
        p2Y = height/2;
        paused = true;
        // Clear arraylist and add new ball
        balls = [];
        balls.push(new Ball(new Vector2D(5, 5)));
    }
    // P to pause/unpause game
    if (key == 'p' || key == 'P') {
        paused = !paused;
    }
    // T to spawn new ball
    if (key == 't' || key == 'T') {
        balls.push(new Ball(new Vector2D(random(-5, 5), random(-5, 5))));
    }
    
    // W/S player 1
    if (key == 'w' || key == 'W') up1 = true;
    if (key == 's' || key == 'S') down1 = true;
    
    // I/K player 2
    if (key == 'i' || key == 'I') up2 = true;
    if (key == 'k' || key == 'K') down2 = true;
}

function keyReleased() {
    // W/S released, set paddle 1 up/down to false
    if (key == 'w' || key == 'W') up1 = false;
    if (key == 's' || key == 'S') down1 = false;
    
    // I/K released, set paddle 2 up/down to false
    if (key == 'i' || key == 'I') up2 = false;
    if (key == 'k' || key == 'K') down2 = false;
}

class Ball {
    // Ball constructor
    // velVec = Vector2D: velocity x, y
    constructor(velVec = new Vector2D(random(-5.0, 5.0), random(-5.0, 5.0))) {
        this.vel = new Vector2D(velVec.x, velVec.y);
        this.pos = new Vector2D(width/2, height/2);
        this.color = color(random(255), random(255), random(255));
        this.ps = [];   // Array of particle systems
    }

    // Checks collisions and updates ball position
    // p1: paddle1 position
    // p2: paddle2 position
    update(p1, p2) {
        // Update ball position
        this.pos.add(this.vel);

        // Top/bottom edge collision; add particle effect
        if (this.pos.y <= 10 || this.pos.y >= height-10) {
            this.vel.y *= -1;
            this.ps.push(new ParticleSystem(new Vector2D(this.pos.x, this.pos.y), this.color));
        }
        // Paddle 1 collision; add particle effect
        if (this.pos.y-10 < p1+40 && this.pos.y+10 > p1-40 &&
            this.pos.x+10 + this.vel.x > width/10-10 && this.pos.x-10 + this.vel.x < width/10+10) {
            this.vel.x *= -1;
            this.ps.push(new ParticleSystem(new Vector2D(this.pos.x, this.pos.y), this.color));
        }
        if (this.pos.y-10 + this.vel.y < p1+40 && this.pos.y+10 + this.vel.y > p1-40 && 
            this.pos.x+10 > width/10-10 && this.pos.x-10 < width/10+10) {
            if (this.pos.y < p1) this.pos.y = p1-50;
            if (this.pos.y > p1) this.pos.y = p1+50;
            this.vel.y *= -1;
        }
        // Paddle 2 collision; add particle effect
        if (this.pos.y-10 < p2+40 && this.pos.y+10 > p2-40 && 
            this.pos.x+10 + this.vel.x> 9*width/10-10 && this.pos.x-10 + this.vel.x < 9*width/10+10) {
            this.vel.x *= -1;
            this.ps.push(new ParticleSystem(new Vector2D(this.pos.x, this.pos.y), this.color));
        }
        if (this.pos.y-10 + this.vel.y < p2+40 && this.pos.y+10 + this.vel.y > p2-40 && 
            this.pos.x+10 > 9*width/10-10 && this.pos.x-10 < 9*width/10+10) {
            if (this.pos.y < p1) this.pos.y = p2-50;
            if (this.pos.y > p1) this.pos.y = p2+50;
            this.vel.y *= -1;
        }
        // Run particle systems
        this.runPS();
    }

    // Runs each particle system, removed empty ones
    runPS() {
        for (let i = 0; i < this.ps.length; i++) {
            this.ps[i].run();
            // If particle system is empty, remove it
            if (this.ps[i].length = 0) this.ps.splice(i, 1);
        }
    }

    // Draw ball
    display() {
        fill(this.color);
        ellipse(this.pos.x, this.pos.y, 20, 20);
    }

    // Reset ball in middle
    // int direction: [-1: towards Player 1] [1: towards Player 2]
    reset(direction) {
        this.pos.x = width/2;
        this.pos.y = height/2;
        this.vel.x = random(direction * 2.0, direction * 5.0);
        this.vel.y = random(-5.0, 5.0);
    }
}

class Particle {
    // Particle constructor
    // posVec = Vector2D: position x, y
    // color = color of this particle
    constructor(posVec = new Vector2D(0, 0), color = color(255)) {
        this.pos = new Vector2D(posVec.x, posVec.y);
        this.color = color;
        this.vel = new Vector2D(random(-1, 1), random(-1, 1));
        this.acc = new Vector2D(random(-0.05, 0.05), random(-0.05, 0.05));
        this.lifespan = 255;
        this.radius = random(10, 20);
    }

    // Draw particle
    display() {
        fill(red(this.color), green(this.color), blue(this.color), this.lifespan);
        ellipse(this.pos.x, this.pos.y, this.radius, this.radius);
    }

    // Update particle position, velocity, and lifespan
    update() {
        this.pos.add(this.vel);
        this.vel.add(this.acc);
        this.lifespan -= 1;
    }

    // True if particle is dead, false otherwise
    isDead() {
        return this.lifespan < 0;
    }
}

class ParticleSystem {
    // ParticleSystem constructor
    // posVec = Vector2D: position x, y
    // color = color of particles in system
    constructor(posVec = new Vector2D(0, 0), color = color(255)) {
        this.pos = new Vector2D(posVec.x, posVec.y);
        this.color = color;
        this.start = millis();  // time PS was created, store current time
        this.particles = [];    // Array of particles in system
    }

    // True if Particle System is dead; false otherwise
    isDead() {
        // Dead if current time is more than 0.2 second after start
        return millis() > this.start + 0.2*1000;
    }

    // Run particle system
    run() {
        // Draw each particle in system
        // If particle is dead, remove it from system
        for (let i = 0; i < this.particles.length; i++) {
            this.particles[i].display();
            this.particles[i].update();
            if (this.particles[i].isDead()) this.particles.splice(i, 1);
        }
        // If particle system is not dead, continue adding particles
        if (!this.isDead()) this.addParticle(this.color);
    }

    // Adds particle to system
    // color: color of particle
    addParticle(color) {
        this.particles.push(new Particle(this.pos, color));
    }
}

class Vector2D {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    add(v2) {
        this.x += v2.x;
        this.y += v2.y;
    }
}