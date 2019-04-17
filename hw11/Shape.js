class Shape {
    // Shape constructor:
    // x: position x
    // y: position y
    // s: number of sides
    // options: Body options
    constructor(x, y, s, options = {}) {
        this.s = s;
        // Polygon with random radius
        this.body = Bodies.polygon(x, y, s, random(8, 14), options);
        // Add shape to body
        World.add(engine.world, this.body);
    }
}