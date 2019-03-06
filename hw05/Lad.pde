public class Lad {
  // Initial positions x,y at frame 0
  public float posX, posY;
  // Initial width, height at frame 0
  public float sizeX, sizeY;
  // Frame offset- first frame to start animation
  // 0 = default starting frame
  public int frameOff = 0;
  
  // Empty constructor: default values
  public Lad() {}
  
  // Lad constructor
  // float pX: frame 0 position X
  // float pY: frame 0 position Y
  // float sX: frame 0 size X (width)
  // float sY: frame 0 size y (height)
  // int f: starting frame
  public Lad(float pX, float pY, float sX, float sY, int f) {
    posX = pX;
    posY = pY;
    sizeX = sX;
    sizeY = sY;
    frameOff = f;
  }
  
  // Draws the body (body + ears)
  // float pX: body center position X
  // float pY: body center position Y
  // float sX: size X (width)
  // float sY: size y (height)
  public void drawBody(float pX, float pY, float sX, float sY) {
    // Pale yellow
    fill(#FFF9D4);
    noStroke();
    // body - ellipse
    ellipse(pX, pY, sX, sY);
    // ears - 2 ellipses
    // ears near top of body, same size for all lads
    ellipse(pX-sX/8, pY-sY/2, 30, 60);
    ellipse(pX+sX/8, pY-sY/2, 30, 60);
  }
  
  // Draws the face (eyes and mouth)
  // float pX: face center position X
  // float pY: face center position Y
  public void drawFace(float pX, float pY) {
    // Purple eyes - 2 ellipses
    fill(#B24085);
    ellipse(pX-sizeX/8, pY-sizeY/8, 5, 5);
    ellipse(pX+sizeX/8, pY-sizeY/8, 5, 5);
    noFill();
    // Pink mouth - 2 arcs
    stroke(#FF76C8);
    arc(pX-15, pY, 30, 30, 0, PI);
    arc(pX+15, pY, 30, 30, 0, PI);
  }
  
  // Animates bounce
  public void animate() {
    // Current frame (between 0-9)
    int frame = (frameOff + frameCount) % 10;
    
    pushMatrix();
    // Translate, center is (0, 0)
    translate(width/2, height/2);
    
    // What to draw for each frame
    // Frame 0-2: neutral, on ground (3 frames)
    // Frame 3-4: stretched, going up (2 frames)
    // Frame 5-7: neutral, in air (3 frames)
    // Frame 8-9: stretched, going down (2 frames)
    if (frame >= 0 && frame <= 2) {
      drawBody(posX, posY, sizeX, sizeY);
      drawFace(posX, posY);
    } else if (frame >= 3 && frame <= 4) {
      drawBody(posX, posY-3*sizeY/4, 3*sizeX/4, sizeY*2);
      // face towards top of body
      drawFace(posX, posY-4*sizeY/5);
    } else if (frame >= 5 && frame <= 7) {
      drawBody(posX, posY-sizeY, sizeX, sizeY);
      drawFace(posX, posY-sizeY);
    } else {
      drawBody(posX, posY-3*sizeY/4, 3*sizeX/4, sizeY*2);
      // face towards bottom of body
      drawFace(posX, posY-2*sizeY/4);
    }
    popMatrix();
  }
}
