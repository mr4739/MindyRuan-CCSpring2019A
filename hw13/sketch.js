var lads = [];          // Array of lads
var songs = [], amp;    // Array of songs, amplitude
var chillButton;        // song change button
var songIndex = 0;      // which song is currently playing
var minHeight = 80, maxHeight = 160;    // Min and max heights of lads

function preload() {
    // load in songs
    songs.push(loadSound("sounds/WretchedWeaponry.mp3"));
    songs.push(loadSound("sounds/Afterlife.mp3"));
}

function setup() {
    createCanvas(window.innerWidth-20, window.innerHeight-40);
    noStroke();
    // Button for toggling songs
    chillButton = createButton("no chill");
    chillButton.mouseClicked(toggleSong);

    // max number of lads horizontally
    var numLadsX = floor(window.innerWidth/100);
    // max number of lads vertically
    var numLadsY = floor(window.innerHeight/120)-2;
    // Make the lads
    for (let j = 0; j < numLadsY; j++) {
        for (let i = 0; i < numLadsX; i++) {
            lads.push(new Lad(50 +(window.innerWidth - numLadsX*100) / 4+ i*100, 160+j*140, 100, 80, 0));
        }
    }
    // Initiate amplitude
    amp = new p5.Amplitude();
    // Loop the current song
    songs[songIndex].loop();
}

// Switches between the two songs
function toggleSong() {
    if (songs[0].isPlaying()) {
        songs[0].stop();
        songs[1].loop();
        // Change button text
        chillButton.html("chill");
    } else {
        songs[1].stop();
        songs[0].loop();
        // Change button text
        chillButton.html("no chill");
    }
}

function draw() {
    // lad's height is amplitude mapped between min/max heights
    let ladHeight = map(amp.getLevel(), 0, 1, minHeight, maxHeight);
    // mouth size also mapped from amplitude
    let mouthX = map(amp.getLevel(), 0, 0.8, 10, 50);
    let mouthY = map(amp.getLevel(), 0, 0.7, 0, 90);
    // purple background
    background("#B24085");
    // Draw each lad
    for (let i = 0; i < lads.length; i++) {
        lads[i].sizeY = ladHeight;
        lads[i].mouthY = mouthY;
        lads[i].mouthX = mouthX;
        lads[i].drawBody();
        lads[i].drawFace();
    }
}

class Lad {
    // pX, pY: lad's position x, y
    // sX, sY: lad's size x, y (width, height)
    constructor(pX = 0, pY = 0, sX = 180, sY = 170) {
        this.posX = pX;
        this.posY = pY;
        this.sizeX = sX;
        this.sizeY = sY;
        this.mouthX = 10;   // default
        this.mouthY = 10;   // default
    }

    drawBody() {
        // Pale yellow
        fill("#FFF9D4");
        noStroke();
        // body - ellipse
        ellipse(this.posX, this.posY, this.sizeX, this.sizeY);
        // ears - 2 ellipses
        // ears near top of body, same size for all lads
        ellipse(this.posX-this.sizeX/8, this.posY-this.sizeY/2, 30, 60);
        ellipse(this.posX+this.sizeX/8, this.posY-this.sizeY/2, 30, 60);
    }

    drawFace() {
        // Purple eyes - 2 ellipses
        fill("#B24085");
        ellipse(this.posX-this.sizeX/8, this.posY-this.sizeY/8, 5, 5);
        ellipse(this.posX+this.sizeX/8, this.posY-this.sizeY/8, 5, 5);
        // Pink mouth
        fill("#FF76C8");
        ellipse(this.posX, this.posY+10, this.mouthX, this.mouthY);
    }
}