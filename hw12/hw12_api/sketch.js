/*
hw12-api/sketch.js
Author: Mindy Ruan
Assignment: Use Processing to work with a data file locally for the first one, 
and p5.js to work with an API for the second one.

API: https://pokeapi.co/
*/

// url for API requests
// index = Pokedex number
var url;
var urlBase = "https://pokeapi.co/api/v2/pokemon/"
var index = 1;

// for preload
var sprite;         // sprite of pokemon
var pkmnName;       // pokemon's name
var loaded;         // boolean: done loading
var img, imgCopy;   // image of pokemon sprite and copy (silhouette)

var cnv;            // container for canvas

// input: input text field element
// ouput: string - for displaying text output
var input, output;
// Button containers
var buttonSubmit, buttonRandom, buttonGiveUp;
// container for element to print output to
var textDisplay;

function preload() {
    // Generate a random valid pokedex index
    index = int(random(1, 808));
    // Append index to url base to generate url
    url = urlBase + index;
    sprite = httpGet(url, 'json', function(response) {
        // Get the pokemon's sprite link
        sprite = response.sprites.front_default;
        // Get the pokemon's name
        pkmnName = response.name;

        // load sprite
        // callback function: resize image and make the silhouette copy
        img = loadImage(sprite, img => {
            img.resize(0, 500);
            imgCopy = createImage(img.width, img.height);
            imgCopy.loadPixels();
            img.loadPixels();
            // For each pixel in img
            // If pixel is not transparent, make it black in the silhouette copy
            for (let i = 0; i < img.pixels.length; i += 4) {
                if (img.pixels[i+3] > 0) {
                    imgCopy.pixels[i] = 0;      // red
                    imgCopy.pixels[i+1] = 0;    // green
                    imgCopy.pixels[i+2] = 0;    // blue
                    imgCopy.pixels[i+3] = 255;  // alpha
                }
            }
            imgCopy.updatePixels();
            // White background
            background(255);
            imageMode(CENTER);
            // Draw the silhouette copy
            image(imgCopy, width/2, height/2);
        });
        loaded = true;
    });
}

function setup() {
    // Get output span element
    textDisplay = document.getElementById("output");
    cnv = createCanvas(window.innerWidth/2, 2*window.innerHeight/3);
    centerCanvas();
    
    // Input text field
    input = createInput();
    input.position(3*window.innerWidth/8, 6*height/5);

    // Submit button for text input
    // On click: validate()
    buttonSubmit = createButton('submit');
    buttonSubmit.position(input.x + input.width, 6*height/5);
    buttonSubmit.mouseClicked(validate);

    // Give up button
    // On click: giveUp()
    buttonGiveUp = createButton('give up');
    buttonGiveUp.position(input.x + input.width + buttonSubmit.width, 6*height/5);
    buttonGiveUp.mouseClicked(giveUp);

    // Random button
    // On click: generateNewPkmn()
    buttonRandom = createButton('random');
    buttonRandom.position(input.x + input.width + 2*buttonSubmit.width, 6*height/5);
    buttonRandom.mouseClicked(generateNewPkmn);

}

// Positions the canvas in the center on page
function centerCanvas() {
    cnv.position(window.innerWidth/4, window.innerHeight/8);
}

// Checks answer
function validate() {
    // Convert input to lowercase letters
    let answer = input.value().toLowerCase();
    // If input is equal to the pokemon's name
    // Draw the unsilhouetted sprite
    // Change output to the pokemon's name
    if (answer == pkmnName) {
        image(img, width/2, height/2);
        output = "<b>IT'S " + pkmnName.toUpperCase() + "!</b>";
    } else {
        // Answer incorrect
        output = "<b>NOPE</b>";
    }
    // Display the output
    textDisplay.innerHTML = output;
    // Clear the input text field
    input.value('');
}

// Reveals correct answer
function giveUp() {
    // Draw the unsilhouetted sprite
    image(img, width/2, height/2);
    // Output correct answer
    output = "<b>IT'S " + pkmnName.toUpperCase() + "!</b>";
    // Display output
    textDisplay.innerHTML = output;
    // Clear input text field
    input.value('');
}

// Randomly select a new pokemon
function generateNewPkmn() {
    // Generate random pokedex index
    index = int(random(1, 808));
    // Create url
    url = urlBase + index;
    // Reset display text
    textDisplay.innerHTML = "<b>WHO'S THAT POKEMON?</b>";
    // Clear input text field
    input.value('');
    // Call preload to get and load everything
    preload();
}

function draw() {
    if (!loaded) {
        return;
    }
}