/*
hw10/hw5Remake/sketch.js
Author: Mindy Ruan
Summary: The 3 bouncy lads are back, but in p5
*/

var lads = [];
// for scrolling terrains
var offset = 0, offset2 = 0;

function setup() {
    createCanvas(windowWidth-20, windowHeight-40);
    noStroke();
    rectMode(CENTER);
    // Add 3 lads to the squad
    lads.push(new Lad(0, 200, 130, 120, 0));
    lads.push(new Lad(300, 175, 180, 170, 5));
    lads.push(new Lad(-300, 175, 180, 170, 3));
}

function draw() {
    // purple background
    background("#B24085");

    // scrolling terrains in background
    for (let i = 0; i < width; i++) {
        // Pink terrain
        stroke("#FF76C8");
        line(i, height, i, height - noise((i+offset)*0.01) * 500);
        // Teal terrain in front of pink, scrolls faster
        stroke("#4AC3CC");
        line(i, height, i, height - noise((i+offset2)*0.01) * 300);
    }
    offset += 3;
    offset2 += 12;

    // Ground - Teal rectangle
    noStroke();
    fill("#4AC3CC");
    rect(width/2, height, width, 320);

    // Animate the lads
    for (let i = 0; i < lads.length; i++) {
        lads[i].animate();
    }
}

class Lad {
    // Lad constructor
    // pX = float: frame 0 position x
    // pY = float: frame 0 position y
    // sX = float: frame 0 size x (width)
    // sY = float: frame 0 size y (height)
    // f = int: starting frame
    constructor(pX = 0, pY = 0, sX = 180, sY = 170, f = 0) {
        this.posX = pX;
        this.posY = pY;
        this.sizeX = sX;
        this.sizeY = sY;
        this.frameOff = f;
    }

    // Draws the body (body + ears)
    // pX = float: body center position X
    // pY = float: body center position Y
    // sX = float: size X (width)
    // sY = float: size y (height)
    drawBody(pX, pY, sX, sY) {
        // Pale yellow
        fill("#FFF9D4");
        noStroke();
        // body - ellipse
        ellipse(pX, pY, sX, sY);
        // ears - 2 ellipses
        // ears near top of body, same size for all lads
        ellipse(pX-sX/8, pY-sY/2, 30, 60);
        ellipse(pX+sX/8, pY-sY/2, 30, 60);
    }

    // Draws the face (eyes and mouth)
    // pX = float: face center position X
    // pY = float: face center position Y
    drawFace(pX, pY) {
        // Purple eyes - 2 ellipses
        fill("#B24085");
        ellipse(pX-this.sizeX/8, pY-this.sizeY/8, 5, 5);
        ellipse(pX+this.sizeX/8, pY-this.sizeY/8, 5, 5);
        noFill();
        // Pink mouth - 2 arcs
        stroke("#FF76C8");
        arc(pX-15, pY, 30, 30, 0, PI);
        arc(pX+15, pY, 30, 30, 0, PI);
    }

    // Animates bounce
    animate() {
        // Current frame (between 0-9)
        let frame = (this.frameOff + frameCount) % 10;
        push();
        // Translate, center is (0, 0)
        translate(width / 2, height / 2);
        // What to draw for each frame
        // Frame 0-2: neutral, on ground (3 frames)
        // Frame 3-4: stretched, going up (2 frames)
        // Frame 5-7: neutral, in air (3 frames)
        // Frame 8-9: stretched, going down (2 frames)
        if (frame >= 0 && frame <= 2) {
            this.drawBody(this.posX, this.posY, this.sizeX, this.sizeY);
            this.drawFace(this.posX, this.posY);
        } else if (frame >= 3 && frame <= 4) {
            this.drawBody(this.posX, this.posY - 3 * this.sizeY / 4, 3 * this.sizeX / 4, this.sizeY * 2);
            // face towards top of body
            this.drawFace(this.posX, this.posY - 4 * this.sizeY / 5);
        } else if (frame >= 5 && frame <= 7) {
            this.drawBody(this.posX, this.posY - this.sizeY, this.sizeX, this.sizeY);
            this.drawFace(this.posX, this.posY - this.sizeY);
        } else {
            this.drawBody(this.posX, this.posY - 3 * this.sizeY / 4, 3 * this.sizeX / 4, this.sizeY * 2);
            // face towards bottom of body
            this.drawFace(this.posX, this.posY - 2 * this.sizeY / 4);
        }
        pop();
    }

}