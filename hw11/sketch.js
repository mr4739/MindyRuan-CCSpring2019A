/*
sketch.js
Author: Mindy Ruan
Assignment: Create a sketch that successfully showcases a natural/physical phenomenon, 
possibly with user input. 

CONTROLS:
*** MOUSE - click and drag non-static shapes
*/

// Module aliases
var Engine = Matter.Engine;
var World = Matter.World;
var Bodies = Matter.Bodies;
var Body = Matter.Body;
var Constraint = Matter.Constraint;
var Render = Matter.Render;
var Mouse = Matter.Mouse;
var MouseConstraint = Matter.MouseConstraint;

// containers
var engine, render;
var cnv, cnvMouse;

// containers for bodies
var shapes = [];
var spinners = [];
var ground;

// Dimensions scale amount
var wScale = 2/3;
// Canvas width and height
var w = 1000, h = 700;

function setup() {
    wScale = pixelDensity();
    cnv = createCanvas(w, h);

    // Create the mouse using the canvas
    cnvMouse = Mouse.create(cnv.elt);
    cnvMouse.pixelRatio = pixelDensity();
    rectMode(CENTER);

    // Create engine
    engine = Engine.create();

    // Create render
    // Hide wireframes, match background color with static objects color
    render = Render.create({
        canvas: cnv.elt,
        engine: engine,
        options: { 
            width: w * wScale,
            height: h * wScale,
            wireframes: false,
            // Comment out this line or change background color to unhide spinners
            background: '#2E2C44',
            // Uncomment this line to show rotation indicators on bodies
            // showAngleIndicator: true,
        }
    })
    
    // Creates dynamic pairs of bouncy shapes bounded by a constraint
    for (let i = 10; i < w; i += 10) {
        shapeA = new Shape(i, 50, int(random(3,9)), {restitution: 1, friction: 0.1});
        shapeB = new Shape(i - 5, 40, int(random(3,9)), {restitution: 1, friction: 0.1});
        // constraint options
        var options = {
            bodyA: shapeA.body,
            bodyB: shapeB.body,
            length: 30,
            stiffness: 1,
            // Comment out this line to show constraint lines between shapes
            render: {visible:false},
        };
        // Create the constraint and add it to the world
        var constraint = Constraint.create(options);
        World.add(engine.world, constraint);
    }

    // Ground body, static
    ground = Bodies.rectangle(475, 650, cnv.width+120, 60, { isStatic: true });
    World.add(engine.world, [ground]);

    // Create 50 static spinners
    // Rotating polygons with random number of sides, alternating directions, and different speeds
    for (let j = 3; j < 8; j++) {
        // Shift even rows to the right
        let offset = j % 2 == 0 ? 45 : 0; 
        for (let i = 0; i < 10; i++) {
            // Even indexed shapes rotate clockwise, odds rotate counterclockwise
            let dir = i % 2 == 0 ? 1 : -1;
            spinners.push(new Wheel(i*100+offset+50, 100*(j-2), int(random(3, 9)), 45, dir * random(0.03, 0.05), { isStatic: true }));
        }
    }

    // Mouse constraint for mouse interaction
    var mConstraint = MouseConstraint.create(engine, { mouse: cnvMouse });
    World.add(engine.world, mConstraint);

    Engine.run(engine);
    Render.run(render);
}

function draw() {
    // Make all spinners rotate
    for (let i = 0; i < spinners.length; i++) {
        spinners[i].spin();
    }
}