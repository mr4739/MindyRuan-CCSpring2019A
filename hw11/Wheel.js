class Wheel {
    // Wheel constructor:
    // x: position x
    // y: position y
    // s: number of sides
    // r: radius
    // speed: rotation speed
    // options: Body options
    constructor(x, y, s, r, speed, options = {}) {
        this.speed = speed;
        this.body = Bodies.polygon(x, y, s, r, options);
        World.add(engine.world, this.body);
    }

    // Rotates the wheel by speed
    spin() {
        Body.rotate(this.body, this.speed);
    }
}