import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;

OpenCV opencv;
Rectangle[] faces;

Capture video;
Movie mov;

long startTime, ellapsed;

int w=640, h=480; //the width and height of the webcam/opencv frame 

void setup() {

  /* set the size of the frame  or fullScreen() */
  //size(640, 480);
  fullScreen();


  video = new Capture(this, w, h);                    //setup the Capture object (for the webcam)
  video.start();  

  opencv = new OpenCV(this, w, h);                    //setup OpenCV object (for face dection) 

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);     //load Haar Cascade (for face dection) 

  faces = new Rectangle[0];                           //setup array to hold bounding boxes of faces

  mov = new Movie(this, "transit.mov");               //load the video to display (remember to replace "transit.mov" with your video)

  /* deal with processing's occational bugginess) */
  mov.play();  
  mov.jump(0);  
  mov.pause();
}

int state = 0;

void draw() {

  switch(state) {

    //wait until you see a face
  case 0: 

    if (video.available()) {     //if there is a frame of webcam available
      video.read();              //get the webcam frame

      image(video, (width-w)/2, (height-h)/2);        //display the webcam frame

      opencv.loadImage(video);   //load the webcam frame into opencv
      faces = opencv.detect();   //find the faces

      //draw rectangles around the faces (only for debugging)
      noFill();
      stroke(0, 255, 0);
      strokeWeight(3);
      for (int i = 0; i < faces.length; i++) {
        rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      }

      if (faces.length > 0) state++;  //if a face is found move on to the next state
    }
    break;

    //Start the video
  case 1:
    mov.play();
    println("Start the video.");
    background(0, 255, 0);            //flash green
    startTime = millis();             //keep track of when the video started playing
    state++;                          //move on to the next state

    //show the video
  case 2:

    ellapsed = millis()-startTime;    //see how many milliseconds since the video started

    println("Playing the video. "+(float)ellapsed/1000.0+" seconds ellapsed of "+mov.duration()+".");

    image(mov, 0, 0, width, height);  //display the current frame of the display video

    /* if the amount of time in seconds since the movie began 
     is greater than the duration of the movie (ie if the movie 
     is over), go back to the start state. */
    if ((float)ellapsed/1000.0 >= mov.duration()) {
      background(0);
      mov.play();  
      mov.jump(0);  
      mov.pause();
      state = 0;
    }

    break;
  default:
    break;
  }//end switch
}

//this is needed to load each frame of the display video.
void movieEvent(Movie m) {
  m.read();
}