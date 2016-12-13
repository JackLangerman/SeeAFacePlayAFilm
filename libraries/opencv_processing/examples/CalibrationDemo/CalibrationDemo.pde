import gab.opencv.*;

PImage src;
ArrayList<PVector> cornerPoints;
OpenCV opencv;

void setup() {
  src = loadImage("checkerboard.jpg");
  //size(src.width, src.height); // this breaks Processing 3.x
  size(1920, 1080);

  opencv = new OpenCV(this, src);
  opencv.gray();
  
  cornerPoints = opencv.findChessboardCorners(3, 4);
}

void draw() {
  image(opencv.getOutput(), 0, 0);
  fill(255,0,0);
  noStroke();
  for(PVector p : cornerPoints){
    ellipse(p.x, p.y, 5, 5);
  }
}